import * as Rbase from "../../rbase_common.js"
import { RbaseController } from "../../rbase_stimulus.js"
import { patch } from "@rails/request.js"

var field_type_regexp = {};
var default_field = {};
var field_type_list_field = {};
var calendar_field = {};
var dt_calendar_field = {};

const SEARCH_FORM_NAME = 'custom_field_conditions';
const FORM_NAME = 'custom_fields';

export default class extends RbaseController {
  connect() {
    super.connect();
  }
  index() {
    super.index();
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue('user');
    }
    initSortableRows();
  }
  
  new() {
    super.new();
    init(this.paramsValue);
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
  }
  
  edit() {
    super.edit();
    init(this.paramsValue);
    
    if (Rbase.getParams('clear') == 'true') {
      Rbase.clearWebStorageFormValue(FORM_NAME);
    }
    Rbase.restoreWebStorageFormValueNoTrigger(FORM_NAME);
  }

  show() {
    super.show();
    Rbase.showFormDisbaled();
    init(this.paramsValue);
  }
  
  custom_field_type_change(event) {
    var target = $(event.target);
    console.log("change custom_field_type_change:"+event.target.name);
    if (target.val() == this.paramsValue.custom_field_type_id) {
      $("#issue_type").show();
    } else {
      $("#issue_type").hide();
    }
  }
  
  field_type_change(event) {
    var target = $(event.target);
    console.log("change field_type_change:"+event.target.name);
    
    display_init(target);
  }
  
  form_change() {
    console.log("[custom_field] => form_change()");
    Rbase.saveWebStorageFormValue($(event.target).prop('id'), FORM_NAME);
  }
}

function init(params) {
  $.each(params["field_type_enum"], function(index, value) {
    field_type_regexp[value["id"]] = value["regexp"];
    default_field[value["id"]] = value["default_field"];
    field_type_list_field[value["id"]] = value["list_field"];
    calendar_field[value["id"]] = value["calendar"];
    dt_calendar_field[value["id"]] = value["dt_calendar"];
  });
  
  $(function() {
    display_init($("#field_type"));
  });
}

function display_init(target) {
  if (field_type_regexp[target.val()] == true) {
    $("#format_regexp").show();
  } else {
    $("#format_regexp").hide();
  }
  if (default_field[target.val()] == true) {
    $("#default_value").show();
  } else {
    $("#default_value").hide();
  }
  if (field_type_list_field[target.val()] == true) {
    $("#list_field").show();
  } else {
    $("#list_field").hide();
  }
  if (calendar_field[target.val()] == true) {
    $("#date_field").show();
  } else {
    $("#date_field").hide();
  }
  if (dt_calendar_field[target.val()] == true) {
    $("#datetime_field").show();
  } else {
    $("#datetime_field").hide();
  }
}

function initSortableRows() {
  const listElement = document.getElementById("custom-field-sortable-list");
  if (!listElement) {
    return;
  }

  const tableElement = listElement.closest("table");
  const sortUrl = tableElement?.dataset.sortUrl;
  if (!sortUrl) {
    return;
  }

  let draggingRow = null;

  listElement.querySelectorAll("tr[data-custom-field-id]").forEach((row) => {
    row.addEventListener("dragstart", (event) => {
      draggingRow = row;
      row.classList.add("table-warning");
      event.dataTransfer.effectAllowed = "move";
      event.dataTransfer.setData("text/plain", row.dataset.customFieldId);
    });

    row.addEventListener("dragend", async () => {
      row.classList.remove("table-warning");
      draggingRow = null;
      await updateSortOrder(listElement, sortUrl);
    });

    row.addEventListener("dragover", (event) => {
      event.preventDefault();
      if (!draggingRow || draggingRow === row) {
        return;
      }

      const targetRect = row.getBoundingClientRect();
      const insertBefore = event.clientY < targetRect.top + targetRect.height / 2;
      listElement.insertBefore(draggingRow, insertBefore ? row : row.nextSibling);
    });
  });
}

async function updateSortOrder(listElement, sortUrl) {
  const customFieldIds = Array.from(listElement.querySelectorAll("tr[data-custom-field-id]"))
    .map((row) => row.dataset.customFieldId);

  const response = await patch(sortUrl, {
    body: { custom_field_ids: customFieldIds },
    contentType: "application/json"
  });

  if (!response.ok) {
    alert("並び順の保存に失敗しました。再読み込みして再実行してください。");
  }
}

