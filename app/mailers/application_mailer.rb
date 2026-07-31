class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  helper :application
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include Devise::Controllers::UrlHelpers

end
