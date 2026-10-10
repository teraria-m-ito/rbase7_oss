import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'

const FORM_NAME = 'workflows';

export default class extends RbaseController {
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
  }
  
  new() {
    super.new();
    var self = this;
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
    
    $(document).off("change.workflowSites");
    $(document).on("change.workflowSites", ".check_sites", async function() {
      var site_ids = new Array();
      $('.check_sites:checked').each(function(){
        site_ids.push($(this).val());
      });
      
      const response = await post(self.paramsValue.url1, {
        body: {
          id: self.paramsValue.workflow_id,
          site_ids: site_ids.join(',')
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
  }
  
  edit() {
    super.edit();
    var self = this;
    initWorkflowStateSortableRows();
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
    
    $(document).off("change.workflowSites");
    $(document).on("change.workflowSites", ".check_sites", async function() {
      var site_ids = new Array();
      $('.check_sites:checked').each(function(){
        site_ids.push($(this).val());
      });
      
      const response = await post(self.paramsValue.url1, {
        body: {
          id: self.paramsValue.workflow_id,
          site_ids: site_ids.join(',')
        },
        contentType: "application/json",
        responseKind: "turbo-stream"
      });
      
      if (response.ok) {
        console.log("success");
      }
    });
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
  
  form_change() {
    console.log("[workflows] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}

// ワークフロー状態の行をドラッグで並べ替え、ドロップ後に表示順を保存する
// edit() は Turbo の画面表示ごとに呼ばれるため、名前空間付きで付け直して重複登録を防ぐ
function initWorkflowStateSortableRows() {
  var LIST_SELECTOR = "#workflow-state-sortable-list";
  var ROW_SELECTOR = LIST_SELECTOR + " tr[data-workflow-state-id]";
  var draggingRow = null;

  $(document).off(".workflowStateSort");

  $(document).on("dragstart.workflowStateSort", ROW_SELECTOR, function(event) {
    draggingRow = this;
    $(this).addClass("table-warning");
    event.originalEvent.dataTransfer.effectAllowed = "move";
    event.originalEvent.dataTransfer.setData("text/plain", $(this).data("workflow-state-id"));
  });

  $(document).on("dragover.workflowStateSort", ROW_SELECTOR, function(event) {
    event.preventDefault();
    if (!draggingRow || draggingRow === this) {
      return;
    }
    var rect = this.getBoundingClientRect();
    if (event.originalEvent.clientY < rect.top + rect.height / 2) {
      $(draggingRow).insertBefore(this);
    } else {
      $(draggingRow).insertAfter(this);
    }
  });

  $(document).on("dragend.workflowStateSort", ROW_SELECTOR, async function() {
    $(this).removeClass("table-warning");
    draggingRow = null;

    var sortUrl = $(LIST_SELECTOR).closest("table").data("sort-url");
    var workflowStateIds = $(ROW_SELECTOR).map(function() {
      return $(this).data("workflow-state-id");
    }).get();

    const response = await patch(sortUrl, {
      body: { workflow_state_ids: workflowStateIds },
      contentType: "application/json"
    });

    if (!response.ok) {
      alert("並び順の保存に失敗しました。再読み込みして再実行してください。");
    }
  });
}
