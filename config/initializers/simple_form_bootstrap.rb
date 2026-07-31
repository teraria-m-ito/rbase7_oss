# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'has-error alert alert-danger'
  config.button_class = 'btn btn-default'
  config.boolean_label_class = nil

  config.default_wrapper = :RbaseFormBuilder

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'control-label'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'control-label'

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group vertical_radio_and_checkboxes', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label'
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end
  
  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    # b.use :html5
    # b.optional :readonly
# 
    # b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
      # wr.wrapper tag: 'div', class: 'checkbox' do |ba|
        # ba.use :label_input, class: 'col-sm-9'
      # end
# 
      # wr.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      # wr.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    # end
  # end
  
  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :input
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      end
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :label
      end
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end

  config.wrappers :horizontal_label_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li' do |li|
        li.use :label, class: 'control-label'
      end
      ul.wrapper tag: 'li' do |li|
        li.use :input, class: 'form-control'
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end
  
  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end


  config.wrappers :horizontal_radio_and_checkboxes2, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-2 control-label'

    b.wrapper tag: 'div', class: 'col-sm-10' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes_no_error, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-2 control-label'

    b.wrapper tag: 'div', class: 'col-sm-10' do |ba|
      ba.use :input
    end
  end
  
  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  ####################
  # 採用分
  config.wrappers :horizontal_input, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-2 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-10" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_nemeric_input, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-9" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_input_wide_label, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-9" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end
  
  config.wrappers :horizontal_input_wide_label_4, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-4 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-8" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end  
  
  config.wrappers :horizontal_boolean_input, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-9 flex" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end  

  config.wrappers :horizontal_boolean_input_label2, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-2 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-10 flex" do |ba|
      ba.use :input, class: ""
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end  
  
  config.wrappers :horizontal_boolean_input_label4, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-4 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-8 flex" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_boolean_input_label6, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label'
    b.wrapper tag: 'div', class: "col-sm-6 flex" do |ba|
      ba.use :input, class: "form-control"
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  #未検証
  config.wrappers :horizontal_input_inline, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li' do |li|
        li.use :label
      end
      ul.wrapper tag: 'li', class: "form-group-inputs" do |li|
        li.use :input, class: 'form-control'
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      end
      ul.wrapper tag: 'li', class: "form-group-inputs" do |li|
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end
  

  # config.wrappers :horizontal_boolean_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    # b.use :html5 
    # b.use :placeholder
    # b.optional :maxlength
    # b.optional :readonly
    # b.wrapper tag: 'ul' do | ul|
      # ul.wrapper tag: 'li' do |li|
        # li.use :label, class: 'control-label'
      # end
      # ul.wrapper tag: 'li', class: "form-group-inputs" do |li|
        # li.use :input
        # li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        # li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      # end
    # end
  # end    
  
  config.wrappers :horizontal_boolean_input_inline, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li' do |li|
        li.use :label
      end
      ul.wrapper tag: 'li', class: "form-group-inputs" do |li|
        li.use :input
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end
  
  config.wrappers :horizontal_boolean_inline, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :input
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      end
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :label
      end
      ul.wrapper tag: 'li', class: "form-group-boolean-inputs" do |li|
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end  
  
  config.wrappers :horizontal_label_input_inline, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li' do |li|
        li.use :label
      end
      ul.wrapper tag: 'li' do |li|
        li.use :input, class: 'form-control'
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end
  
  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5 
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.optional :col
    b.wrapper tag: 'ul' do | ul|
      ul.wrapper tag: 'li' do |li|
        li.use :label, class: 'control-label'
      end
      ul.wrapper tag: 'li', class: "form-group-inputs" do |li|
        li.use :input, collection_wrapper_class: "form-check form-check-inline"
        li.use :error, wrap_with: { tag: 'span', class: 'help-block' }
        li.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end

  config.wrappers :default_input_form, tag: false do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: "control-label", error_class: "has-error"
    b.use :input, class: "form-control", error_class: "has-error"
  end

  config.boolean_style = :inline

  config.wrappers :default_radio_and_checkboxes, tag: false do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: "control-label", error_class: "has-error"
    b.use :input, class: "form-check-input", error_class: "has-error"
  end

  # config.wrappers :default_input_form_label3, tag: false, error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :readonly
  #   b.use :label, class: "col-md-3 control-label"
  #   b.use :input, class: "col-md-5 form-control"
  #   b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #   b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  # end

  # config.wrappers :default_input_form_label3, tag: false do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :readonly
  #   b.use :label, class: "col-md-3 control-label"
  #   b.wrapper tag: 'div', class: "input-group-sm" do |ba|
  #     ba.use :input, class: "col-sm-9 form-control"
  #     ba.use :error, wrap_with: { tag: 'p', class: 'text-danger small help-block' }
  #     ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  #   end
  # end

  config.wrappers :default_select_form, tag: false do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: "control-label", error_class: "has-error"
    b.use :input, class: "form-control", error_class: "has-error"
  end

  config.wrappers :default_boolean_form, tag: false do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :label_input
    end
  end

  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.

  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    string: :default_input_form,
    numeric: :default_input_form,
    email: :default_input_form,
    password: :default_input_form,
    # string: :horizontal_input,
    select: :default_select_form,
    # select: :horizontal_input,
    check_boxes: :default_radio_and_checkboxes,
    radio_buttons: :default_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :default_boolean_form,
    integer: :default_input_form,
    text: :default_input_form,
    datetime: :default_input_form,
    datetime_local: :default_input_form,
    label: :default_input_form
  }



end
