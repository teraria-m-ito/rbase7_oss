import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'

export default class extends RbaseController {
  new() {
    super.new();
    console.log("new for queries");
    Rbase.restoreWebStorageFormValueNoTrigger('issues/search_conditions');
    
    $(document).off("submit", "form");
    $(document).on("submit", "form", function(){
      $('div[style*="display: none"]').each(function(){
        $(this).find('input,select').each(function() {
          $(this).remove();
        });
      });
    });
  }

  edit() {
    super.new();
    console.log("edit for queries");
    
    $(document).off("submit", "form");
    $(document).on("submit", "form", function(){
      $('div[style*="display: none"]').each(function(){
        $(this).find('input,select').each(function() {
          $(this).remove();
        });
      });
    });
  }

  show() {
    super.show();
    console.log("show for queries");
    Rbase.showFormDisbaled();
  }
}
