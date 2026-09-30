import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'


const SEARCH_FORM_NAME = 'job_manages/search_conditions';
const FORM_NAME = 'job_manage';

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
    $("form").on("change", function(e) {
      Rbase.saveWebStorageFormValue($(e.target).prop('id'), SEARCH_FORM_NAME);
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
}
