import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'

const FORM_NAME = 'workflows';

export default class extends RbaseController {
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue('user');
    }
  }
  
  new() {
    super.new();
    var self = this;
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
    
    $(".check_sites").change(async function() {
      var site_ids = new Array();
      $('.check_sites:checked').each(function(){
        site_ids.push($(this).val());
      });
      
      const response = await post(self.paramsValue.url1, {
        body: {
          id: self.paramsValue.workflow_id,
          site_ids: site_ids.join(',')
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
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
    
    $(".check_sites").change(async function() {
      var site_ids = new Array();
      $('.check_sites:checked').each(function(){
        site_ids.push($(this).val());
      });
      
      const response = await post(self.paramsValue.url1, {
        body: {
          id: self.paramsValue.workflow_id,
          site_ids: site_ids.join(',')
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
  
  form_change() {
    console.log("[workflows] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
