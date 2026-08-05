import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const SEARCH_FORM_NAME = 'search_translation';
const FORM_NAME = 'form_translation';

export default class extends RbaseController {
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(SEARCH_FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(SEARCH_FORM_NAME);
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
  
  search_form_change() {
    console.log("[translation] => search_form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), SEARCH_FORM_NAME);
  }
  form_change() {
    console.log("[translation] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
