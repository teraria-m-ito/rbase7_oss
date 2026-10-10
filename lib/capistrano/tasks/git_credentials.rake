# frozen_string_literal: true

require "cgi"
require "stringio"

# :git_http_username / :git_http_password（GitHub では PAT）を、URL に埋め込まずに git へ渡す。
# 権限 700 のディレクトリに credential store 形式のファイルを置き、
# GIT_CONFIG_PARAMETERS で credential.helper として指定する（git -c と同じ仕組みで、サブモジュールにも引き継がれる）。
# ファイルはデプロイ終了時（成功・失敗とも）に削除する。

namespace :git do
  desc "HTTPS 用の資格情報を一時ファイルとしてアップロードする"
  task :upload_credentials do
    user = fetch(:git_http_username, nil)
    pass = fetch(:git_http_password, nil)
    next if user.to_s.empty? || pass.to_s.empty?

    host = CapistranoGitSubmodulesRelease.git_remote_host(fetch(:repo_url))
    next unless fetch(:repo_url).to_s.start_with?("https://") && host

    credential_dir = "#{fetch(:tmp_dir)}/#{fetch(:application)}-git-credentials"
    credential_file = "#{credential_dir}/credentials"
    on release_roles(:all) do
      execute :mkdir, "-p", "-m", "700", credential_dir
      execute :chmod, "700", credential_dir
      upload!(StringIO.new("https://#{CGI.escape(user.to_s)}:#{CGI.escape(pass.to_s)}@#{host}\n"), credential_file)
      execute :chmod, "600", credential_file
    end

    set :git_credential_dir, credential_dir
    set :git_environmental_variables,
        fetch(:git_environmental_variables).merge(GIT_CONFIG_PARAMETERS: "'credential.helper=store --file=#{credential_file}'")
  end

  desc "HTTPS 用の資格情報の一時ファイルを削除する"
  task :remove_credentials do
    credential_dir = fetch(:git_credential_dir, nil)
    next if credential_dir.nil?

    on release_roles(:all) do
      execute :rm, "-rf", credential_dir
    end
  end
end

after "git:wrapper", "git:upload_credentials"
after "deploy:finished", "git:remove_credentials"
after "deploy:failed", "git:remove_credentials"
