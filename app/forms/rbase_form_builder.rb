class RbaseFormBuilder < SimpleForm::FormBuilder

  def input(attribute_name, options = {}, &block)
    options = @defaults.deep_dup.deep_merge(options) if @defaults

    options[:input_hint] = options.delete(:hint)
    input   = find_input(attribute_name, options, &block)
    wrapper = find_wrapper(input.input_type, options)

    wrapper.render input
  end
end