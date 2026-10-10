# frozen_string_literal: true

# Capistrano::SCM::Git#git_repo_url は :git_http_username / :git_http_password があると
# 常に URI.parse(repo_url) で HTTPS 用にユーザー・パスワードを埋め込む。
# 埋め込むとデプロイログや repo/config（remote.origin.url）に PAT が残るため、URL はそのまま返す。
# HTTPS の資格情報は lib/capistrano/tasks/git_credentials.rake の credential store 経由で渡す。
# また :repo_url が git@host:path や ssh:// のときは URI として解釈できず例外になるため、その回避も兼ねる。
module CapistranoGitRepoUrlSshFix
  def git_repo_url
    url = repo_url.to_s
    return url if fetch(:git_http_username, nil) || fetch(:git_http_password, nil)

    super
  end
end

Capistrano::SCM::Git.prepend(CapistranoGitRepoUrlSshFix)
