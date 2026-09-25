module ApplicationHelper
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  def render_top
    render "common/top"
  end

  def render_aside
    render "common/aside"
  end
  def flash_messages
    @flash_messages ||= flash.to_hash.with_indifferent_access.except(*::Rails.application.flash_keys_to_except)
  end

  def is_action?(action)
    case action
      when :sign_up
        (params[:controller] == "admin_users/registrations" && params[:action] == "create") ||
        (params[:controller] == "admin_users/registrations" && params[:action] == "new")
      when :log_in
        (params[:controller] == "devise/sessions" && params[:action] == "create") ||
        (params[:controller] == "devise/sessions" && params[:action] == "new")
      when :forgot_password
        (params[:controller] == "devise/passwords" && params[:action] == "create") ||
            (params[:controller] == "devise/passwords" && params[:action] == "new") ||
            (params[:controller] == "devise/passwords" && params[:action] == "update") ||
            (params[:controller] == "devise/passwords" && params[:action] == "edit")
    end
  end

  def enable_action?(url, method = nil)
    return true if current_admin_user.admin?
    access_url = method.nil? ? Rails.application.routes.recognize_path(url) : Rails.application.routes.recognize_path(url, method: method)
    controller_name = access_url[:controller]
    action_name = access_url[:action]

    user_role_action = current_admin_user.role.role_actions.where(controller_path: controller_name).where(action_name: action_name).first

    user_role_action.present?
  end

  def show_check(m)
    "<i class=\"fa fa-check\"></i>".html_safe if m == true
  end

  def site_list
    ::Site.all
  end

  def custom_field_input(form, options={})
    return if form.object.custom_field.nil?
    options = options.merge({label: form.object.custom_field.field_name})
    case form.object.custom_field.field_type
    when "list"
      options.update({as: :select, collection: form.object.custom_field.default_value.split(",")})
    when "date"
      options.update({input_html: {class: 'datepicker'}})
    else
      custom_field_input_else_field_type(form, options)
    end
    options.update({required: true}) if form.object.custom_field.required
    # field_size の col だけを足す（update で input_html を置き換えると institution の select_institution 等が消える）
    if form.object.custom_field.field_size
      options[:input_html] = (options[:input_html] || {}).merge(col: form.object.custom_field.field_size.to_i)
    end
    options.update({label: form.object.custom_field.display_name})
    safe_join([
                form.input(:field_value, options),
                form.input(:custom_field_id, as: :hidden, input_html: {value: form.object.custom_field.id})
              ])
  end

  private
  def custom_field_input_else_field_type(form, options);end
  def search_condition_custom_field_input_else_field_type(form, custom_field, options);end
  public

  def search_condition_custom_field_input(form, custom_field, options={})
    return if custom_field.nil?

    field_id = custom_field.id
    value = form.object.custom_field_values[field_id.to_s]
    input_html = (options.delete(:input_html) || {}).merge(
      id: "#{form.object_name}_custom_field_values_#{field_id}",
      name: "#{form.object_name}[custom_field_values][#{field_id}]",
      value: value
    )
    input_html[:col] = custom_field.field_size.to_i if custom_field.field_size && !input_html.key?(:col)

    options = options.merge(
      label: custom_field.display_name,
      required: false,
      input_html: input_html
    )

    case custom_field.field_type
    when "list"
      options.update(
        as: :select,
        collection: custom_field.default_value.to_s.split(","),
        include_blank: true,
        selected: value
      )
    when "date"
      options[:input_html][:class] = [options[:input_html][:class], "datepicker"].compact.join(" ")
    else
      search_condition_custom_field_input_else_field_type(form, custom_field, options)
    end

    form.input(:custom_field_values, options)
  end

  def active_site_selected
    !current_admin_user.try(:selected_site).blank?
  end

  def active_site_name
    Site.find(current_admin_user.selected_site.to_i == 0 ? current_admin_user.sites.first.id : current_admin_user.selected_site).site_name
  end

  def get_current_site_id
    Thread.current[:request].session[:active_site_id]
  end

  def full_admin_user_name(admin_user)
    bu_name = admin_user.bu_name.blank? ? "未登録" : admin_user.bu_name
    unit_name = admin_user.unit_name.blank? ? "未登録" : admin_user.unit_name
    "#{bu_name}/#{unit_name}/#{admin_user.name}"
  end

  def split_object_content(content_string, size)
    split_length =  size
    #split_length = SystemSetting[:alert_string, session[:active_site_id]]

    result = content_string

    unless split_length.nil?
      if content_string.length > split_length
        result = "<div data-toggle='tooltip' data-html='true' data-original-title='#{br(content_string)}'>" + content_string[0..split_length - 1] + ".."+"</div>"
#        result = content_string[0..split_length - 1] + ".."
      end
    end

    return result
  end

  def split_name(name,size=20)
    result = name
    split_length = size
    if name.length > size
      result = name[0..split_length - 1] + "..."
    end
    result
  end

  def ellipsis_object_content(content_string, line=2, height=20)
    split_line =  line
    line_height = height
    result = content_string.nil? ? "" : content_string
    unless content_string.nil? || content_string.length == 0
      result = "<div class='ellipsis' data-toggle='tooltip' data-html='true' data-original-title='#{br(content_string)}'>#{content_string}</div>"
      result += <<-"EOS"
        <style>
          .ellipsis {
            overflow: hidden;
            height: #{line_height*split_line}px;
          }
        </style>
      EOS
    end
    return result
  end

  def ellipse_script(line=2)
    result = <<-"EOS"
          $('.ellipsis').each(function() {
            var $target = $(this);
            var html = $target.attr('data-original-title');
            var $clone = $target.clone();
            $clone.css({
              display: 'none',
              position : 'absolute',
              overflow : 'visible'
            }).width($target.width()).height('auto');
            $target.after($clone);
            htmls = html.split(/<br>|<br \\\/>/)
            line = htmls.length <= #{line+1} ? htmls.length : #{line+1}
            html = '';
            for(var i=0;i<line;i++){
                html += htmls[i] + '<br \\/>'
            }
            $clone.html(html);
            while((html.length > 0) && ($clone.height() > $target.height())) {
              if(html.match(/<br>$/)){
                html = html.replace(/<br>$/,"");
              }else if(html.match(/<br \\\/>$/)){
                html = html.replace(/<br \\\/>$/,"");
              }else{
                html = html.substr(0, html.length - 1);
              }
              $clone.html(html + '…');
              $target.html($clone.html());
              $clone.width($target.width());
            }
            if($clone.html().slice(-1)=='…'){
              if($clone.html().match(/<br>…$/)){
                $clone.html($clone.html().replace(/<br>…$/,"…"));
              }else if($clone.html().match(/<br \\/>…$/)){
                $clone.html($clone.html().replace(/<br \\/>…$/,"…"));
              }
              $target.tooltip('enable');
            }else{
              $target.tooltip('disable');
            }
            $target.html($clone.html());
            $clone.remove();
          });
    EOS
  end

  def br(str)
    html_escape(str).gsub(/\r\n|\r|\n/, "<br />").html_safe
  end

  def is_displayed_admin_page?
    if session[:current_page]
      if /^\/admin(?!_)/ =~ session[:current_page][:controller] or /^admin(?!_)/ =~ session[:current_page][:controller]
        true
      else
        false
      end
    end
  end

  def is_current_page?(menu_url)
    current_page = ""
    begin
      current_page = url_for(session[:current_page])
    rescue
      current_page = url_for(request.path)
    end
    if current_page.start_with?(menu_url.split("?")[0])
      true
    else
      false
    end
  end

  def js_controller_name
    raw = session[:current_page][:controller]
    raw.slice(1..).sub("/", "--")
  end

  #伝票専用の為汎用性は作っていない
  def is_request_from?(controller)
    return false if session[:voucher_edits_referer].nil?
    referer = Rails.application.routes.recognize_path(session[:voucher_edits_referer])
    ::Rails.logger.debug("[ApplicationHelper][is_request_from?]controller:#{controller} referer[:controller]:#{referer[:controller]}")
    controller == referer[:controller]
  end


  def display_creator_name(voucher)
    voucher.uploader_id.nil? ? voucher.creator_name : voucher.uploader_name
  end

  def display_updater_name(voucher)
    case voucher.issue.state_name
    when "業務チェック完了", "ファイル出力済", "検収依頼済"
      result = voucher.checked_name
    when "検収済"
      result = voucher.approved_name
    else
      result = ""
    end
    result
  end

  def display_require_mark
    I18n.t("simple_form.required.html").html_safe
  end

  def date_string(d)
    return "" if d.blank?
    d.strftime(I18n.t(:date_format))
  end

  def datetime_string(d)
    return "" if d.blank?
    d.strftime(I18n.t(:datetime_format))
  end

  def datetime_min_string(d)
    return "" if d.blank?
    d.strftime(I18n.t(:datetime_min_format))
  end

  def convert_rf(str)
    str.gsub(/\n/, "<br/>").html_safe
  end

  def table_sort(label, field_name, default=false)
    result = label
    session[@model_name] = {} if session[@model_name].nil?
    field_session = session[@model_name][field_name]
    if field_session.present? && field_session[:direction].present?
      if field_session[:direction] == :asc
        result = "<i class='fa fa-caret-up sorted'></i>"
      elsif field_session[:direction] == :desc
        result = "<i class='fa fa-caret-down sorted'></i>"
      end
    else
      result = "<i class='fa fa-caret-down unsorted'></i>"
    end
    join_letter = @sort_url.include?("?") ? "&" : "?"
    page_letter = @page_number.nil? ? "" : "&page=#{@page_number}"
    link = link_to "#{@sort_url}#{join_letter}sort_field_name=#{field_name}#{page_letter}", class: "sort_button" do
      result.html_safe
    end
    loading = image_tag "loading.gif", class: "loading_image"
    (label + link +  hidden_field_tag("#{@model_name}/#{field_name}_direction", nil) + loading).html_safe
  end

  def current_site_id
    session[:active_site_id]
  end

  def date_to_str_yyyymmdd(d)
    d.nil? ? "" : d.strftime("%Y/%m/%d")
  end

  def date_to_str_yyyymmddhhmmss(d, term="/")
    d.nil? ? "" : d.strftime("%Y#{term}%m#{term}%d %H:%M:%S")
  end

  def grid_row(f, &block)
    content = capture(&block)
    cls = "form-group form-inline input-group-sm"
    cls += " has-error" if f.object.errors.any?
    tag.div(class: cls) do
      content.html_safe
    end
  end

  def display_fixed_string(str, length)
    result = ""
    if str.size >= length
      result = str[0..length - 1] + "..."
    else
      result = str
    end
    result
  end

  def content_tag_push(tag_name, *options)
    children_buffer = ActiveSupport::SafeBuffer.new

    adder = ->(child_tag, *child_options, &child_block) do
      if child_block
        children_buffer << content_tag_push(child_tag, *child_options, &child_block)
      else
        content = child_options.shift
        children_buffer << content_tag(child_tag, content, *child_options)
      end
      nil
    end

    result = block_given? ? yield(adder) : nil

    if result.is_a?(String) || result.is_a?(ActiveSupport::SafeBuffer)
      children_buffer << result
    end
    content_tag(tag_name, children_buffer, *options)
  end

  def require_sso_logout?
    site_id = current_site_id ? current_site_id : Site.first.id
    require_sso_logout = ::SystemSetting.get_setting(:require_sso_logout, site_id)
    require_sso_logout == "1"
  end
end