# coding: utf-8

namespace :rbase do
  desc "setup admin_user for rbase."
  task :setup_admin_user => :environment do
    site = Site.first || Site.create!(site_name: "demo")

    role = Role.first || Role.create!(role_name: "Administorator", role_short_name: "admin")

    if AdminUser.count == 0
      admin_user = AdminUser.new(email: "admin@example.com", name: "admin", status_div: "accepted", password: "CHANGE_ME")
      admin_user.role = role

      admin_user_site = AdminUserSite.new
      admin_user_site.site = site
      admin_user_site.admin_user = admin_user

      admin_user.admin_user_sites << admin_user_site

      begin
        admin_user.save!(validate: false)
      rescue
        puts "error:#{admin_user.errors.full_messages}"
      end
    end
  end

  desc "reset admin_user for rbase."
  task :reset_admin_user => :environment do
    admin_user = AdminUser.where(name: "admin").first
    admin_user = AdminUser.find(1) unless admin_user
    if admin_user
      puts "reset password:id:#{admin_user.id}"
      admin_user.password = "CHANGE_ME"
      admin_user.save!
    else
      puts "reset password:admin user not found...."
    end
  end
end
