import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const SEARCH_FORM_NAME = 'state_flow_conditions';
const FORM_NAME = 'state_flow';


export default class extends RbaseController {
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(SEARCH_FORM_NAME);
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(SEARCH_FORM_NAME);
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);

    $(".check_for_check_state_flow_workflow_states").change(function() {
      var isChecked = $(this).prop('checked');
      var target_field_name = $(this).prop('name').replace(/next_workflow_state_id/g,'current_workflow_state_id')
      var target_field = $("input[name*='" + target_field_name + "']")
      var target_destroy_field = "#" + $(this).prop('id') + '_destroy'
      if(isChecked) {
        $(target_field).prop("checked", true);
        $(target_destroy_field).prop("value", false);
      } else {
        $(target_field).prop("checked", false);
        $(target_destroy_field).prop("value", true);
      }
      console.log($(target_field).val());
    });
    
    $(document).off("click", "#button_select_all");
    $(document).on("click", "#button_select_all", function() {
      $(".check_workflow_state").each(function() {
        $(this).prop("checked", true );
        var target_field = "#" + $(this).prop('id') + '_destroy'
        $(target_field).prop("value", false);
      });
    });
    $(document).off("click", "#button_unselect_all");
    $(document).on("click", "#button_unselect_all", function() {
      $(".check_workflow_state").each(function() {
        $(this).prop("checked", false );
        var target_field = "#" + $(this).prop('id') + '_destroy'
        $(target_field).prop("value", true);
      });
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  search_form_change() {
    console.log("[state_flows] => search_form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), SEARCH_FORM_NAME);
  }
  
  form_change() {
    console.log("[state_flows] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
  
  
}
