import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'

// Turbo 遷移後も document のハンドラは残るため、対象はクエリの登録・編集フォームに限定する
const QUERY_FORM_SELECTOR = 'form.new_query, form.edit_query';

export default class extends RbaseController {
  new() {
    super.new();
    console.log("new for queries");
    Rbase.restoreWebStorageFormValueNoTrigger('issues/search_conditions');
    
    $(document).off("submit.queryForm");
    $(document).on("submit.queryForm", QUERY_FORM_SELECTOR, function(){
      $(this).find('div[style*="display: none"]').each(function(){
        $(this).find('input,select').each(function() {
          $(this).remove();
        });
      });
    });
  }

  edit() {
    super.new();
    console.log("edit for queries");
    
    $(document).off("submit.queryForm");
    $(document).on("submit.queryForm", QUERY_FORM_SELECTOR, function(){
      $(this).find('div[style*="display: none"]').each(function(){
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
