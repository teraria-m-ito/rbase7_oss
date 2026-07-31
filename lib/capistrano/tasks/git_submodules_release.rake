# frozen_string_literal: true

require "cgi"
require "uri"

# :repo_url が git@github.com:user/repo.git のように SSH 形式のとき、
# URI.parse できないためホスト判定に使う。
module CapistranoGitSubmodulesRelease
  module_function

  def git_remote_host(repo_url)
    s = repo_url.to_s.strip
    return nil if s.empty?

    if s.start_with?("git@")
      s.sub(/\Agit@/, "").split(":", 2).first
    elsif s.start_with?("ssh://")
      URI.parse(s).host
    elsif (m = s.match(%r{\Ahttps?://([^/]+)}))
      m[1]
    else
      URI.parse(s).host
    end
  rescue URI::InvalidURIError
    nil
  end
end

# Capistrano の標準 Git プラグインは git archive でリリースを作るため、
# サブモジュール配下のファイルは展開されない（親リポジトリの gitlink のみ）。
# set :git_submodules, true のときは、ミラーから git clone でリリースを作り、
# その後 git submodule update でサブモジュールを取得する。
#
# git clone --recursive は .gitmodules の URL のまま clone するため、
# プライベートな GitHub HTTPS サブモジュールでは認証が付かず失敗する。
# :git_http_username / :git_http_password（GitHub では PAT）が設定されている場合は、
# 親リポジトリと同一ホストの submodule URL に同じ資格情報を埋め込んでから update する。
#
# 参考: https://stackoverflow.com/questions/19403138/capistrano-v3-deploy-git-repository-and-its-submodules

Rake::Task["git:create_release"].clear_actions

namespace :git do
  desc "Copy repo to releases (with submodules when :git_submodules is true)"
  task create_release: :'git:update' do
    on release_roles(:all), in: :groups, limit: fetch(:git_max_concurrent_connections), wait: fetch(:git_wait_interval) do
      with fetch(:git_environmental_variables) do
        within repo_path do
          if fetch(:git_submodules, false)
            if fetch(:repo_tree, nil)
              warn "[git:create_release] :repo_tree が設定されているためサブモジュール用 clone は使えません。git archive にフォールバックします。"
              execute :mkdir, "-p", release_path
              tar = SSHKit.config.command_map[:tar]
              tree = fetch(:repo_tree).slice(%r{\A/?(.*?)/?\z}, 1)
              components = tree.split("/").size
              execute :git, :archive, fetch(:branch), tree, "| #{tar} -x --strip-components #{components} -f - -C", release_path
            else
              execute :rm, "-rf", release_path
              branch = fetch(:branch).to_s
              clone_args = %w[clone --single-branch]
              if (depth = fetch(:git_shallow_clone, false))
                clone_args.push("--depth", depth.to_s)
              end
              clone_args.push("-b", branch, ".", release_path.to_s)
              execute :git, *clone_args
            end
          else
            execute :mkdir, "-p", release_path
            tar = SSHKit.config.command_map[:tar]
            if (tree = fetch(:repo_tree, nil))
              tree = tree.slice(%r{\A/?(.*?)/?\z}, 1)
              components = tree.split("/").size
              execute :git, :archive, fetch(:branch), tree, "| #{tar} -x --strip-components #{components} -f - -C", release_path
            else
              execute :git, :archive, fetch(:branch), "| #{tar} -x -f - -C", release_path
            end
          end
        end

        if fetch(:git_submodules, false) && fetch(:repo_tree, nil).nil?
          within release_path do
            execute :git, :submodule, "init"

            user = fetch(:git_http_username, nil)
            pass = fetch(:git_http_password, nil)
            if user && !pass.to_s.empty?
              parent_host = CapistranoGitSubmodulesRelease.git_remote_host(fetch(:repo_url))
              match_parent_only = fetch(:git_submodule_auth_match_parent_host_only, true)
              escaped_pass = CGI.escape(pass.to_s)

              raw = capture(:git, "config", "-f", ".gitmodules", "--get-regexp", "^submodule\\..*\\.url$")
              raw.strip.each_line do |line|
                key, url = line.strip.split(/\t+/, 2)
                key, url = line.strip.split(/\s+/, 2) if url.nil?
                next if url.nil? || url.empty?

                path = key.delete_prefix("submodule.").delete_suffix(".url")
                # git@host:path.git や ssh:// は URI.parse できない。HTTPS 埋め込みは https のみ対象。
                next unless url.start_with?("https://")

                uri = URI.parse(url)
                next unless uri.scheme == "https"
                next if match_parent_only && parent_host && uri.host != parent_host

                uri.user = user.to_s
                uri.password = escaped_pass
                execute :git, :config, "submodule.#{path}.url", uri.to_s
              end
            else
              warn "[git:create_release] :git_http_username / :git_http_password が未設定です。" \
                   "プライベートな HTTPS サブモジュールは clone に失敗する可能性があります。"
            end

            execute :git, :submodule, "update", "--recursive"
            # 既定 false: Gemfile の git: ソース解決などがリリース直下の .git を参照するため削除しない
            execute :rm, "-rf", release_path.join(".git") if fetch(:git_trim_release_git_dir, false)
          end
        end
      end
    end
  end
end
