class StringInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    html_type = input_html_options[:type].to_s
    if html_type == "datetime" || html_type == "datetime-local"
      return DatetimePickerInput.new(@builder, attribute_name, column, :datetime_picker, options).input(wrapper_options)
    end

    unless string?
      input_html_classes.unshift("string")
      input_html_options[:type] ||= input_type if html5?
    end

    input_html_classes << wrapper_options[:error_class] if has_errors?
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    col = merged_input_options.delete(:col) || "auto"
    no_custom = merged_input_options.delete(:no_custom)

    unless no_custom
      error_text = has_errors? ? errors.send(error_method) : ""

      template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
        template.concat(@builder.text_field(attribute_name, merged_input_options))
        template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
        template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
      end
    else
      @builder.text_field(attribute_name, merged_input_options)
    end
  end
end

module SimpleForm
  module Inputs
    class CollectionSelectInput < CollectionInput
      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods

        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""
          template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
            template.concat(@builder.collection_select(
              attribute_name, collection, value_method, label_method,
              input_options, merged_input_options
            ))
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          @builder.collection_select(
            attribute_name, collection, value_method, label_method,
            input_options, merged_input_options
          )
        end
      end
    end
  end
end

module SimpleForm
  module Inputs
    class PasswordInput < Base
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""

          template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
            template.concat(@builder.password_field(attribute_name, merged_input_options))
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          @builder.password_field(attribute_name, merged_input_options)
        end
      end
    end

    class NumericInput < Base
      def input(wrapper_options = nil)
        input_html_classes.unshift("numeric")
        if html5?
          input_html_options[:type] ||= "number"
          input_html_options[:step] ||= integer? ? 1 : "any"
        end

        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""

          template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
            template.concat(@builder.text_field(attribute_name, merged_input_options))
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          @builder.text_field(attribute_name, merged_input_options)
        end
      end
    end

    class TextInput < Base
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""

          template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
            template.concat(@builder.text_area(attribute_name, merged_input_options))
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          @builder.text_area(attribute_name, merged_input_options)
        end
      end
    end

    class LabelInput < Base
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        col = merged_input_options.delete(:col) || "auto"

        label_value = merged_input_options.delete(:value) || self.object.send(attribute_name)

        template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
          template.concat(template.content_tag(:p, label_value, {class: "control-input-label"}))
          template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
          template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
        end
      end
    end
  end
end

# module SimpleForm
#   module Components
#     module Labels
#       # module ClassMethods #:nodoc:
#       #   def label(wrapper_options = nil)
#       #     label_options = merge_wrapper_options(label_html_options, wrapper_options)
#       #
#       #     merged_label_options = label_options.merge(wrapper_options[:error_class]) if has_errors?
#       #
#       #     if generate_label_for_attribute?
#       #       @builder.label(label_target, label_text, merged_label_options)
#       #     else
#       #       template.label_tag(nil, label_text, merged_label_options)
#       #     end
#       #   end
#       # end
#       def label(wrapper_options = nil)
#         label_options = merge_wrapper_options(label_html_options, wrapper_options)
#
#
#         if generate_label_for_attribute?
#           @builder.label(label_target, label_text, label_options)
#         else
#           template.label_tag(nil, label_text, label_options)
#         end
#       end
#     end
#
#   end
# end

module SimpleForm
  module Inputs
    class CollectionRadioButtonsInput < CollectionInput
      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods

        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)
        form_vertical = merged_input_options.delete(:form_vertical)

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""

          form_align = form_vertical.nil? ? "form-inline" : ""
          template.content_tag(:div, nil, {class: "input-group-sm col-#{col} #{form_align} "}) do
            template.concat(
              @builder.send(:"collection_#{input_type}",
                            attribute_name, collection, value_method, label_method,
                            input_options, merged_input_options,
                            &collection_block_for_nested_boolean_style
              )
            )
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          @builder.send(:"collection_#{input_type}",
                        attribute_name, collection, value_method, label_method,
                        input_options, merged_input_options,
                        &collection_block_for_nested_boolean_style
          )
        end
      end

      protected

      def apply_default_collection_options!(options)
        options[:item_wrapper_tag] ||= options.fetch(:item_wrapper_tag, SimpleForm.item_wrapper_tag)
        options[:item_wrapper_class] = [
          item_wrapper_class, options[:item_wrapper_class], SimpleForm.item_wrapper_class,
          "form-check"
        ].compact.presence if SimpleForm.include_default_input_wrapper_class

        options[:collection_wrapper_tag] ||= options.fetch(:collection_wrapper_tag, SimpleForm.collection_wrapper_tag)
        options[:collection_wrapper_class] = [
          options[:collection_wrapper_class], SimpleForm.collection_wrapper_class
        ].compact.presence
      end
    end
  end
end

# 日時ピッカー。画面では as: :datetime_picker を使う。datetime_local は使わない。
# date_click_time は start（00:00:00）または end（23:59:59）。省略時は項目名から決める。
# 時刻の動きは rbase_common.js
# 日付だけは DatePickerInput（as: :date_picker）。見た目は同じカレンダーで、保存文字列は yyyy/MM/dd。
class DatetimePickerInput < SimpleForm::Inputs::Base
  def date_only?
    false
  end

  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    col = merged_input_options.delete(:col) || "auto"
    no_custom = merged_input_options.delete(:no_custom)
    click_time = nil
    unless date_only?
      click_time = options[:date_click_time] || merged_input_options.delete(:date_click_time)
      click_time = click_time.to_s.presence
      if click_time.blank?
        attr = attribute_name.to_s
        click_time = if attr.match?(/(?:_to|_end|end_at)\z/)
          "end"
        elsif attr.match?(/(?:_from|_start|start_at)\z/)
          "start"
        end
      end
    end
    display_format = date_only? ? "%Y/%m/%d" : "%Y/%m/%d %H:%M:%S"
    merged_input_options.delete(:step)

    group_style = nil
    if (width = merged_input_options[:style].to_s[/max-width:\s*([^;]+)/, 1]&.strip).present?
      group_style = "width: #{width}; max-width: 100%;"
      rest_style = merged_input_options[:style].to_s.sub(/max-width:\s*[^;]+;?\s*/, "").strip
      rest_style.present? ? merged_input_options[:style] = rest_style : merged_input_options.delete(:style)
    end

    dom_id = merged_input_options[:id].presence || "#{@builder.object_name}_#{attribute_name}".gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    group_id = "#{dom_id}_picker"
    raw_value = merged_input_options.key?(:value) ? merged_input_options[:value] : (object.public_send(attribute_name) if object.respond_to?(attribute_name))
    merged_input_options[:id] = dom_id
    merged_input_options[:type] = "text"
    merged_input_options[:autocomplete] = "off"
    merged_input_options[:value] = if raw_value.blank?
      ""
    elsif raw_value.is_a?(String)
      text = raw_value.strip
      calendar = text.match(/\A(\d{4})[\/-](\d{1,2})[\/-](\d{1,2})(?:[ T](\d{1,2}):(\d{2})(?::(\d{2}))?)?\z/)
      impossible_calendar = calendar && (
        !Date.valid_date?(calendar[1].to_i, calendar[2].to_i, calendar[3].to_i) ||
        (calendar[4] && (
          !(0..23).cover?(calendar[4].to_i) ||
          !(0..59).cover?(calendar[5].to_i) ||
          !(0..59).cover?((calendar[6] || 0).to_i)
        ))
      )
      if impossible_calendar
        text
      elsif !date_only? && text.match?(/\A\d{4}[\/-]\d{2}[\/-]\d{2}\z/)
        suffix = click_time == "end" ? "23:59:59" : "00:00:00"
        parsed = (Time.zone.parse("#{text} #{suffix}") rescue nil)
        parsed ? I18n.l(parsed, format: display_format) : text
      elsif text.match?(/\A\d{4}[\/-]\d{2}[\/-]\d{2}(?:[ T]\d{2}:\d{2}(?::\d{2})?)?\z/)
        parsed = (Time.zone.parse(text) rescue nil)
        parsed ? I18n.l(parsed, format: display_format) : text
      else
        text
      end
    else
      I18n.l(raw_value, format: display_format)
    end
    classes = Array(merged_input_options[:class])
    classes << "datetimepicker-input" unless classes.include?("datetimepicker-input")
    merged_input_options[:class] = classes
    data = (merged_input_options[:data] || {}).to_h
    data[:target] = "##{group_id}"
    merged_input_options[:data] = data

    group_data = { target_input: "nearest" }
    group_data[:date_click_time] = click_time if click_time
    group_class = date_only? ? "input-group date rbase-datetimepicker rbase-datepicker" : "input-group date rbase-datetimepicker"
    group_options = { class: group_class, id: group_id, data: group_data }
    group_options[:style] = group_style if group_style.present?
    group = template.content_tag(:div, group_options) do
      template.concat(@builder.text_field(attribute_name, merged_input_options))
      template.concat(
        template.content_tag(:button, type: "button", class: "rbase-datetimepicker-toggle", tabindex: "-1", aria: { label: "カレンダー" }, data: { toggle: "datetimepicker", target: "##{group_id}" }) do
          template.content_tag(:i, "", class: "fa-regular fa-calendar")
        end
      )
    end

    return group if no_custom

    error_text = has_errors? ? errors.send(error_method) : ""
    template.content_tag(:div, class: "input-group-sm col-#{col}") do
      template.concat(group)
      template.concat(template.content_tag(:p, error_text, class: "text-danger small help-block")) if has_errors?
      template.concat(template.content_tag(:p, options[:input_hint], class: "help-block"))
    end
  end
end

class DatePickerInput < DatetimePickerInput
  def date_only?
    true
  end
end

# カラム型 datetime の form.input。date / time は従来の入力のまま。
class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    if input_type == :datetime
      DatetimePickerInput.new(@builder, attribute_name, column, :datetime_picker, options).input(wrapper_options)
    else
      super
    end
  end

  private

  def label_target
    return attribute_name if input_type == :datetime

    super
  end
end

module SimpleForm
  module Tags
    module CollectionExtensions
      private

      def render_collection
        item_wrapper_tag   = @options.fetch(:item_wrapper_tag, :span)
        item_wrapper_class = @options[:item_wrapper_class]

        @collection.map do |item|
          value = value_for_collection(item, @value_method)
          text  = value_for_collection(item, @text_method)
          default_html_options = default_html_options_for_collection(item, value)
          additional_html_options = option_html_attributes(item)

          rendered_item = yield item, value, text, default_html_options.merge(additional_html_options)

          if @options.fetch(:boolean_style, SimpleForm.boolean_style) == :nested
            label_options = default_html_options.slice(:index, :namespace)
            label_options['class'] = @options[:item_label_class]
            rendered_item = @template_object.label(@object_name, sanitize_attribute_name(value), rendered_item, label_options)
          end

          item_wrapper_tag ? @template_object.content_tag(item_wrapper_tag, rendered_item, class: item_wrapper_class) : rendered_item
        end.join.html_safe
      end
    end
  end
end

module SimpleForm
  module Inputs
    class BooleanInput < Base
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        col = merged_input_options.delete(:col) || "auto"
        no_custom = merged_input_options.delete(:no_custom)

        input_form = nil
        if nested_boolean_style?
          input_form = build_hidden_field_for_checkbox +
            template.label_tag(nil, class: boolean_label_class) {
              build_check_box_without_hidden_field(merged_input_options) +
                inline_label
            }
        else
          if include_hidden?
            input_form = build_check_box(unchecked_value, merged_input_options)
          else
            input_form = build_check_box_without_hidden_field(merged_input_options)
          end
        end

        unless no_custom
          error_text = has_errors? ? errors.send(error_method) : ""

          template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
            template.concat(input_form)
            template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
            template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
          end
        else
          input_form
        end
      end
    end
  end
end

