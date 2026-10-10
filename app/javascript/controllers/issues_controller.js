import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'


const SEARCH_FORM_NAME = 'issues/search_conditions';
const FORM_NAME = 'issue';

export default class extends RbaseController {
  index() {
    super.index();
    var self = this;
    console.log("index for issues");
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(SEARCH_FORM_NAME);
    }
    
    if (Rbase.getParams('edited') != 'true') {
      Rbase.restoreWebStorageFormValueNoTrigger(SEARCH_FORM_NAME);
    }
    // index() は Turbo Stream の適用ごとに呼ばれるため、名前空間付きで付け直して重複登録を防ぐ
    $(document).off("change.issuesSearch");
    $(document).on("change.issuesSearch", "#new_issues_search_conditions", function(e) {
      Rbase.saveWebStorageFormValue($(e.target).prop('id'), SEARCH_FORM_NAME);
    });

    $(document).off("submit", "#new_issues_search_conditions");
    $(document).on("submit", "#new_issues_search_conditions", function(){
      $('div[style*="display: none"]').each(function(){
        $(this).find('input,select').each(function() {
          $(this).remove();
        });
      });
    });

    $(document).off('change', "#select_field_type");
    $(document).on('change', "#select_field_type", async function() {
      const response = await patch(self.paramsValue.url1, {
        body: {
          target_class: self.paramsValue.data_type,
          select_field_type: $(this).prop('value')
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");

        var url = document.location.href;
        if (url.indexOf("/issues") !== -1) {
          Rbase.restoreWebStorageFormValueWithLock(SEARCH_FORM_NAME);
        }
      }
    });
    
    $(document).off("click.issuesShowQuery");
    $(document).on("click.issuesShowQuery", "#button_show_query", async function() {
      const response = await get(self.paramsValue.url2, {
        query: {
          target_class: self.paramsValue.data_type
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
  }
  
  new() {
    super.new();

    var self = this;
    console.log("new for issues");
    
    if (Rbase.getParams('edit_clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);

    $(document).off('change', "#issue_type_id");
    $(document).on('change', "#issue_type_id", async function() {
      const response = await post(self.paramsValue.url, {
        body: {
          issue_type_id: $(this).prop('value')
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
  }

  edit() {
    super.edit();

    var self = this;
    console.log("edit for issues");
    
    if (Rbase.getParams('edit_clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);

    $(document).off('change', "#issue_type_id");
    $(document).on('change', "#issue_type_id", async function() {
      const response = await post(self.paramsValue.url, {
        body: {
          issue_type_id: $(this).prop('value')
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  search_form_change() {
    console.log("[issues] => search_form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), SEARCH_FORM_NAME);
  }
  
  form_change() {
    console.log("[issues] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
