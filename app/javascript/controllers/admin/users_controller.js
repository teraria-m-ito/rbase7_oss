import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const FORM_NAME = 'user';

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
    
    $("#toggle-password").on('click', function() {
      if ($('#admin_user_password').attr('type') == 'password') {
        $('#admin_user_password').attr('type','text');
        $(this).removeClass('bi-eye-slash');
        $(this).addClass('bi-eye');
      } else {
        $('#admin_user_password').attr('type','password');
        $(this).removeClass('bi-eye');
        $(this).addClass('bi-eye-slash');
      }
    });
    
    $("#toggle-password-confirm").on('click', function() {
      if ($('#admin_user_password_confirmation').attr('type') == 'password') {
        $('#admin_user_password_confirmation').attr('type','text');
        $(this).removeClass('bi-eye-slash');
        $(this).addClass('bi-eye');
      } else {
        $('#admin_user_password_confirmation').attr('type','password');
        $(this).removeClass('bi-eye');
        $(this).addClass('bi-eye-slash');
      }
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  form_change() {
    console.log("[users] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
