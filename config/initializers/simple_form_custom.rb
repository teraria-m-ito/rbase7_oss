class StringInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
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

class DatetimeLocalInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    col = merged_input_options.delete(:col) || "auto"
    no_custom = merged_input_options.delete(:no_custom)

    unless no_custom
      error_text = has_errors? ? errors.send(error_method) : ""

      template.content_tag(:div, nil, {class: "input-group-sm col-#{col}"}) do
        template.concat(@builder.text_field(attribute_name, merged_input_options.merge(type: 'datetime-local')))
        template.concat(template.content_tag(:p, error_text, {class: "text-danger small help-block"})) if has_errors?
        template.concat(template.content_tag(:p, options[:input_hint], {class: "help-block"}))
      end
    else
      @builder.text_field(attribute_name, merged_input_options.merge(type: 'datetime-local'))
    end
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

