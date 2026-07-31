import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'


const SEARCH_FORM_NAME = 'system_setting_conditions';
const FORM_NAME = 'system_setting';

function initFunc(self) {
  $('#fileupload').fileupload({
    downloadTemplateId: null,
    sequentialUploads: false,
    method: 'patch',
    url: self.paramsValue.url2,
    submit: function (e, data) {
      console.log("submit:" + data.files.length);
      if (data.files.length > 0) {
        console.log("file:" + data.files[0].name);
      }
      return true;
    },
    done: function (e, data) {
      $("form").submit();
    }
  });
  
  $(document).off("click", "input[type='submit']");
  $(document).on("click", "input[type='submit']", function() {
    console.log("submit");
    if (window.confirm(self.paramsValue.confirm_message)) {
      if ($(".template-upload").length > 0) {
        $(".template-upload-files").each(function() {
          var $template_upload_file = $(this);
          if ($(this).find(".template-upload").length > 0) {
            var $upload_btn = $template_upload_file.parent().find("#upload-btn");
            $upload_btn.click();
          }
        });
      } else {
        $("form").submit();
      }
    }
    return false;
  });
}
export default class extends RbaseController {
  index() {
    super.index();
    console.log("system_settings => index");
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(SEARCH_FORM_NAME);
    }
    
    $(document).off("change", "#new_eport_analytics_teachers_search_conditions");
    $(document).on("change", "#new_eport_analytics_teachers_search_conditions", function(e) {
      Rbase.saveWebStorageFormValue($(e.target).prop('id'), SEARCH_FORM_NAME);
    });
    
    Rbase.restoreWebStorageFormValueNoTrigger(SEARCH_FORM_NAME);

  }
  
  new() {
    super.new();
    var self = this;
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
    
    $(document).off("change", "select[id=system_setting_setting_category_div]");
    $(document).on("change", "select[id=system_setting_setting_category_div]", async function(e) {
      console.log("change system_setting_setting_category_div");

      const response = await post(self.paramsValue.url1, {
        body: $('form').serializeJSON(),
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });

    $(document).off("change", "select[id=system_setting_setting_div]");
    $(document).on("change", "select[id=system_setting_setting_div]",async function(e) {
      console.log("change system_setting_setting_div");

      const response = await post(self.paramsValue.url1, {
        body: $('form').serializeJSON(),
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
    
    setTimeout(function() {
      initFunc(self);
    }, 1000);
  }
  
  edit() {
    super.edit();
    var self = this;
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);

    $(document).off("change", "select[id=system_setting_setting_category_div]");
    $(document).on("change", "select[id=system_setting_setting_category_div]", async function(e) {
      console.log("change system_setting_setting_category_div");

      const response = await patch(self.paramsValue.url1, {
        body: $('form').serializeJSON(),
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });

    $(document).off("change", "select[id=system_setting_setting_div]");
    $(document).on("change", "select[id=system_setting_setting_div]",async function(e) {
      console.log("change system_setting_setting_category_div");

      const response = await patch(self.paramsValue.url1, {
        body: $('form').serializeJSON(),
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
    
    setTimeout(function() {
      initFunc(self);
    }, 1000);
    
  }
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  search_form_change() {
    console.log("[system_settings] => search_form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), SEARCH_FORM_NAME);
  }
  
  form_change() {
    console.log("[system_settings] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
  
}
