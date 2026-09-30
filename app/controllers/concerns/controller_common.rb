module ControllerCommon
  extend ActiveSupport::Concern

  private
  def is_current_page?(url)
    current_page = ""
    begin
      current_page = url_for(session[:current_page])
    rescue
      current_page = url_for(request.path)
    end
    if current_page.start_with?(url.split("?")[0])
      true
    else
      false
    end
  end
  public
end
