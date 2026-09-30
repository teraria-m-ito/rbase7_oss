require("blueimp-file-upload/js/jquery.iframe-transport.js")
require("blueimp-file-upload/js/jquery.fileupload.js")
require("blueimp-file-upload/js/jquery.fileupload-process.js")
require("blueimp-file-upload/js/jquery.fileupload-image.js")
require("blueimp-file-upload/js/jquery.fileupload-audio.js")
require("blueimp-file-upload/js/jquery.fileupload-video.js")
require("blueimp-file-upload/js/jquery.fileupload-validate.js")
require("blueimp-file-upload/js/jquery.fileupload-ui.js")

import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"

const FORM_NAME = 'report';

export default class extends RbaseController {
  connect() {
    super.connect();
    $("#button_upload").click(function() {
      console.log("click");
      return forced_upload();
    });
  }
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue('report');
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
    console.log("[reports] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}
