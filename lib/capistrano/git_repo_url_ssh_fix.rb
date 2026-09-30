# frozen_string_literal: true

# Capistrano::SCM::Git#git_repo_url は :git_http_username / :git_http_password があると
# 常に URI.parse(repo_url) で HTTPS 用にユーザー・パスワードを埋め込む。
# :repo_url が git@host:path や ssh:// のときは URI として解釈できず例外になる。
#
# SSH のときは URL をそのまま返し、親リポジトリの clone/fetch は GIT_SSH 等で認証する。
# HTTPS のサブモジュール用 PAT は lib/capistrano/tasks/git_submodules_release.rake で使う。
module CapistranoGitRepoUrlSshFix
  def git_repo_url
    url = repo_url.to_s
    if fetch(:git_http_username, nil) || fetch(:git_http_password, nil)
      return url if url.start_with?("git@") || url.start_with?("ssh://")
    end
    super
  end
end

Capistrano::SCM::Git.prepend(CapistranoGitRepoUrlSshFix)
