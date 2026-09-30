import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const FORM_NAME = 'workflow_state';

export default class extends RbaseController {
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
  }
  
  new() {
    super.new();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
  }
  
  edit() {
    super.edit();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  form_change() {
    console.log("[workflow_state] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
