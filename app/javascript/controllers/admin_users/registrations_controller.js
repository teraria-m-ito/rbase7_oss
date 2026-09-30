import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'


const SEARCH_FORM_NAME = 'admin_users/search_conditions';
const FORM_NAME = 'admin_user';

export default class extends RbaseController {
  edit() {
    super.edit();

    var self = this;
    console.log("edit for admin_users");
    
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
}
