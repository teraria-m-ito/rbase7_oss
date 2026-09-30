require "test_helper"
require "rake"
class AdminUserTest < ActiveSupport::TestCase
  test "the truth" do
    ::Rails.application.load_tasks
    # ::Rake::Task['rbase_cc:update_servers_info'].invoke("server_problems","moodle-dev6")
    ::Rake::Task['rbase:setup_role'].invoke()
    assert true
  end
end
