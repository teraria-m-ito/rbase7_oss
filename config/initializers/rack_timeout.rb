# module Rack
#   module DynamicTimeout
#     def call(env)
#       target = [
#         "/lms_user_imports",
#         "/lti/reflection_imports",
#         "/lti/reflection_participant_imports",
#         "/lti/showcase_imports",
#         "/lti/showcase_participant_imports"
#       ]
#       unless target.select {|x| env['REQUEST_URI'].start_with?(x)}.blank?
#         @service_timeout = 60 * 3
#         @wait_timeout = 60 * 4
#         @wait_overtime = 60 * 5
#         @service_past_wait = false
#       else
#         @service_timeout = 60 * 30
#         @wait_timeout = 60 * 30
#         @wait_overtime = 60 * 30
#         @service_past_wait = false
#       end
#       super(env)
#     end
#   end
# end
# Rack::Timeout.prepend Rack::DynamicTimeout
#
