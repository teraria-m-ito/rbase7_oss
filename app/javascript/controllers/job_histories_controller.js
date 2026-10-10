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
    // index() は Turbo Stream の適用ごとに呼ばれるため、名前空間付きで付け直して重複登録を防ぐ
    $(document).off("change.jobHistoriesSearch");
    $(document).on("change.jobHistoriesSearch", "form.new_job_histories_search_conditions", function(e) {
      Rbase.saveWebStorageFormValue($(e.target).prop('id'), SEARCH_FORM_NAME);
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
}
