ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# Ruby 3.1+ では logger が default gem 化。bootsnap 経由で ActiveSupport が先に読まれると
# ActiveSupport::LoggerThreadSafeLevel 内で ::Logger が未定義になり NameError になる。
require "logger"
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
