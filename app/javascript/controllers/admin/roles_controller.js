import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const FORM_NAME = 'role';

export default class extends RbaseController {
  connect() {
    super.connect();
    $(".check_role").change(function() {
      var isChecked = $(this).prop('checked');
      var target_field = "#" + $(this).prop('id') + '_destroy'
      console.log(target_field);
      if (isChecked) {
        $(target_field).prop("value", false);
      } else {
        $(target_field).prop("value", true);
      }
      console.log($(target_field).val());
    });
    $("#button_select_all").click(function() {
      $(".check_for_role").each(function() {
        $(this).prop("checked", true);
        var target_field = "#" + $(this).prop('id') + '_destroy'
        $(target_field).prop("value", false);
      });
    });
    $("#button_unselect_all").click(function() {
      $(".check_for_role").each(function() {
        $(this).prop("checked", false);
        var target_field = "#" + $(this).prop('id') + '_destroy'
        $(target_field).prop("value", true);
      });
    });
  }
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue('role');
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
    console.log("[roles] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
