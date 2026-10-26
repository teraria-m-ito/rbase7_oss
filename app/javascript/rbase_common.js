require("./lib/jquery_global")

function admin_init() {
  $(function() {
  });
}

function restoreWebStorageFormValue(model_name) {
  $(function() {
    for (var key in localStorage) {
      if (key.indexOf(model_name) != -1) {
        if (key.indexOf("-button-plus") != -1) {
          var keyAfter = key.replace(model_name + "/", "");
          if (localStorage[key] == "multi") {
            $("#"+keyAfter).trigger("click");
          }
        }
      }
    }
    $('input, select, textarea').each(function(index) {
      var input = $(this);
      var val = null;
      val = localStorage.getItem(model_name + '/' + input.prop('id'));
      if (val != null) {
        if (input.prop('type') == 'checkbox') {
          input.prop('checked', (val == 'true'));
        } else {
          if (input.prop('multiple') == true) {
            var arry = new Array();
            arry = val.split(",");
            for(var i = 0; i<arry.length; i++){
              $("#" + input.prop('id') + " option[value='" + arry[i] + "']").prop("selected", true);
            }
          } else {
            input.prop('value', val);
          }
        }
      }
    });
  
    $('input, select, textarea').each(function(index) {
      var input = $(this);
      var val = null;
      val = localStorage.getItem(model_name + '/' + input.prop('id'));
      if (val != null) {
        input.trigger('change');
      }
    });
  });
}

var lockFlag = false;
  
function restoreWebStorageFormValueWithLock(model_name) {
  $(function() {
    lockFlag = true;
    for (var key in localStorage) {
      if (key.indexOf(model_name) != -1) {
        if (key.indexOf("-button-plus") != -1) {
          var keyAfter = key.replace(model_name + "/", "");
          if (localStorage[key] == "multi") {
            $("#"+keyAfter).trigger("click");
          }
        }
      }
    }
    $('input, select').each(function(index) {
      var input = $(this);
      var val = null;
      if (!input.hasClass("no-restore")) {
        val = localStorage.getItem(model_name + '/' + input.prop('id'));
        if (val != null) {
          if (input.prop('type') == 'checkbox') {
            input.prop('checked', (val == 'true'));
          }
          if (input.prop('type') == 'radio') {
            //ラジオボタンの場合、IDを削除したキーで保存しているので復元してcheckを入れる
            var ids = input.prop('id').split("_");
            ids.pop();
            ids = ids.join("_");
            val = localStorage.getItem(model_name + '/' + ids);
            var id = ids + "_" + val;
            if (id == input.prop('id')) {
              input.prop('checked', true);
            }
          }
          if (input.prop('type').indexOf('select') !== -1) {
            input.trigger('change');
            input.prop('value', val);
          } else {
            input.prop('value', val);
          }
        }
      }
     });
    lockFlag = false;
  });
}
  
function restoreWebStorageFormValueWhenLoad(model_name) {
  $(function() {
    lockFlag = true;
    $('input, select').each(function(index) {
      var input = $(this);
      var val = null;
      val = localStorage.getItem(model_name + '/' + input.prop('id'));
      if (val != null) {
        if (input.prop('type') == 'checkbox') {
          input.prop('checked', (val == 'true'));
          input.trigger('change');
        }
        if (input.prop('type').indexOf('select') !== -1) {
          input.trigger('change');
        }
      }
    });
    lockFlag = false;
  });
}
  
function restoreWebStorageFormValueNoTrigger(model_name) {
  $(function() {
    lockFlag = true;
    $('input, select').each(function (index) {
      var input = $(this);
      var val = null;
      var ids = null;
      //ラジオボタンの場合は、選択肢ごとにIDが振られるので、復元ができなくなる。末尾のID部分を削除して登録している
      if (input.prop('type') == 'radio') {
        ids = input.prop('id').split("_");
        ids.pop();
        ids = ids.join("_");
        if (localStorage.getItem(model_name + '/' + ids) !== null) {
          val = localStorage.getItem(model_name + '/' + ids);
        } else {
          val = null;
        }
      } else {
        if (localStorage.getItem(model_name + '/' + input.prop('id')) !== null) {
          val = localStorage.getItem(model_name + '/' + input.prop('id'));
        } else {
          val = null;
        }
      }

      if (val != null) {
        if (input.prop('type') == 'checkbox') {
          input.prop('checked', (val == 'true'));
        } else if (input.prop('type') == 'radio') {
          //ラジオボタンの場合、IDを削除したキーで保存しているので復元してcheckを入れる
          var id = ids + "_" + val;
          if (id == input.prop('id')) {
            input.prop('checked', true);
          }
        } else {
          input.prop('value', val);
        }
      }
    });
    $('textarea').each(function (index) {
      var input = $(this);
      var val = null;
      val = localStorage.getItem(model_name + '/' + input.prop('id'));
      if (val != null) {
        input.html(val);
      }
    });

    lockFlag = false;
  });
}

function lockFunc() {
  return lockFlag;
}

function getParams(param_name) {
  var url = location.href;
  var parameters = url.split("?");
  if (parameters.length <= 1) {
    return null;
  }
  var params  = parameters[1].split("&");
  var paramsArray = [];
  for (var i = 0; i < params.length; i++ ) {
    var neet = params[i].split("=");
    paramsArray.push(neet[0]);
    paramsArray[neet[0]] = neet[1];
  }
  var categoryKey = paramsArray[param_name];
  return categoryKey;
}
  
function showFormDisbaled() {
  $(function() {
    $("input").each(function() {
      if ($(this).hasClass("show-enable")) {
        return true;
      }
      if ($(this).prop('type') == 'submit' || $(this).prop('type') == 'button' || $(this).prop('type') == 'hidden') {
      } else {
        $(this).prop("disabled", true);
        $(this).css('background', 'white');
        $(this).css('cursor', 'default');
      }
    });
    $("select").each(function() {
      if ($(this).hasClass("show-enable")) {
        return true;
      }
      $(this).prop("disabled", true);
      $(this).css('background', 'white');
      $(this).css('cursor', 'default');
    });
    $("textarea").each(function() {
      if ($(this).hasClass("show-enable")) {
        return true;
      }
      $(this).prop("disabled", true);
      $(this).css('background', 'white');
      $(this).css('cursor', 'default');
    });
  });
}

function showFormEnaled() {
  $(function() {
    $("input").each(function() {
      $(this).prop("disabled", false);
    });
    $("select").each(function() {
      $(this).prop("disabled", false);
    });
    $("textarea").each(function() {
      $(this).prop("disabled", false);
    });
  });
}

function getQueryField(s) {
  var result = "single"
  if (s === "single") {
    result = "multi"
  } else {
    result = "single"
  }
  return result;
}

function saveWebStorageFormValue(field_id, model_name) {
  var fields = $('[id='+field_id+']');
  var val = null;
  $.each(fields, function(i, field) {
    if ($(field).is(':visible')) {
      val = $(field).prop('value');
      if ($(field).prop('type') == 'select-multiple') {
        val = $(field).val();
        if (val instanceof Array) {
          val = val.join(",");
        }
      }
      if ($(field).prop('type') == 'checkbox') {
        val = $(field).prop('checked');
      }
    }
    //ラジオボタンの場合は、選択肢ごとにIDが振られるので、復元ができなくなる．末尾のID部分を削除して登録する
    if ($(field).prop('type') == 'radio') {
      var ids = $(field).prop('id').split("_");
      ids.pop();
      ids = ids.join("_");
      localStorage.setItem(model_name + '/' + ids, val);
    } else {
      if (val != null) {
        localStorage.setItem(model_name + '/' + $(field).prop('id'), val);
      }
    }
  });
}

function saveWebStorageFormHiddenValue(field_id, model_name) {
  var fields = $('[id='+field_id+']');
  var val = null;
  $.each(fields, function(i, field) {
    val = $(field).prop('value');
    if ($(field).prop('type') == 'select-multiple') {
      val = $(field).val();
      if (val instanceof Array) {
        val = val.join(",");
      }
    }
    if ($(field).prop('type') == 'checkbox') {
      val = $(field).prop('checked');
    }
    if (val == "") {
      localStorage.removeItem(model_name + '/' + $(field).prop('id'));
    } else {
      localStorage.setItem(model_name + '/' + $(field).prop('id'), val);
    }
  });
}

function saveWebStorageFormHiddenValueNoRemove(field_id, model_name) {
  var fields = $('[id='+field_id+']');
  var val = null;
  $.each(fields, function(i, field) {
    val = $(field).prop('value');
    if ($(field).prop('type') == 'select-multiple') {
      val = $(field).val();
      if (val instanceof Array) {
        val = val.join(",");
      }
    }
    if ($(field).prop('type') == 'checkbox') {
      val = $(field).prop('checked');
    }

    localStorage.setItem(model_name + '/' + $(field).prop('id'), val);
  });
}
function trigger_only_visible(field_id, trigger_name) {
  var fields = $('[id='+field_id+']');
  $.each(fields, function(i, field) {
    if ($(field).is(':visible')) {
      $(field).trigger(trigger_name);
    }
  });
}

function clearWebStorageFormValue(model_name) {
  for (var key in localStorage) {
    if (key.indexOf(model_name+"/") != -1) {
      delete localStorage[key];
    }
  }
}

function disableWhenElementHide(element_class) {
  var targets = $("."+element_class+":hidden");
  targets.each(function() {
    var targers = $(this).find("input,select,textarea");
    targers.each(function() {
      if ($(this).prop('type') != 'submit' && $(this).prop('type') != 'button') {
        if ($(this).prop("disabled") == false) {
          $(this).prop("disabled",true);
        }
      }
    });
  });
  
  targets = $("."+element_class+":visible");
  targets.each(function() {
    var targers = $(this).find("input,select,textarea");
    targers.each(function() {
      if ($(this).prop('type') != 'submit' && $(this).prop('type') != 'button') {
        if ($(this).prop("disabled") == true) {
          $(this).prop("disabled",false);
        }
      }
    });
  });
}

function initValueWebStorageFormValue(form_id, form_name) {
  let targers = $(form_id).find("input,select,textarea");
  targers.each(function() {
    if ($(this).prop('type') != 'submit' && $(this).prop('type') != 'button' && $(this).prop('type') != 'hidden') {
      saveWebStorageFormValue($(this).prop('id'), form_name);
    }
  });
}

var positionX;
var STORAGE_KEY = "scrollX";
var TABLE_SCROLL_STORAGE_PREFIX = "tableScrollX:";
var TABLE_SCROLL_EVENT_NS = "tableScrollPreserve";

function resetTableXOffset(){
    localStorage.setItem(STORAGE_KEY, 0);
}

function saveTableXOffset(){
    positionX = $(".table-responsive").scrollLeft();
    localStorage.setItem(STORAGE_KEY, positionX);
}

function restoreTableXOffset() {
  positionX = localStorage.getItem(STORAGE_KEY);
  $(".table-responsive").scrollLeft(Number(positionX));
  console.log("scroll->"+positionX);

  $(".table-responsive").off("scroll.tableXOffset").on("scroll.tableXOffset", function() {
    saveTableXOffset();
  });
}

/*
 * 一覧テーブルの横スクロール位置を、ソート（Turbo Stream 差し替え）後も保持する。
 *
 * 操作ログの restoreTableXOffset とは別系統。こちらはテーブルごとに
 * data-table-scroll-key でキーを分け、sessionStorage に保存する。
 *
 * 【HTML】
 *   <div class="table-responsive is-scroll-pending"
 *        id="canvas-users-table-scroll"
 *        data-table-scroll-key="canvas_users">
 *     <table class="table table-fixed ...">...</table>
 *   </div>
 *   <%= render partial: "common/table_scroll_restore",
 *              locals: { element_id: "canvas-users-table-scroll" } %>
 *
 *   - id は一意。bindTableScrollPreserve / restoreTableScroll に渡す。
 *   - data-table-scroll-key は画面ごとの保存キー（clearTableScroll の引数と同じ）。
 *   - is-scroll-pending は復元まで非表示にするクラス（ちらつき防止）。
 *   - ソートリンクは table_sort ヘルパーの .sort_button であること。
 *
 * 【Stimulus（index）】
 *   Rbase.bindTableScrollPreserve("canvas-users-table-scroll");
 *   if (Rbase.getParams("clear") == "true") {
 *     Rbase.clearTableScroll("canvas_users");
 *   }
 *
 * 【API】
 *   saveTableScroll(elementOrId)     現在位置を保存
 *   restoreTableScroll(elementOrId)  保存位置へ戻し is-scroll-pending を外す
 *   bindTableScrollPreserve(id?)     復元＋scroll/ソートで保存。id 省略時は
 *                                    [data-table-scroll-key] 全部が対象
 *   clearTableScroll(scrollKey)      保存を削除（data-table-scroll-key の値）
 *
 * 初回表示は module 読み込み前にインラインスクリプトが走るため、
 * 復元は common/table_scroll_restore 側でも行う。
 */
function tableScrollStorageKey(el) {
  var suffix = (el && el.getAttribute("data-table-scroll-key")) || "default";
  return TABLE_SCROLL_STORAGE_PREFIX + suffix;
}

function tableScrollDomElement(elementOrId) {
  if (!elementOrId) {
    return null;
  }
  if (typeof elementOrId === "string") {
    return document.getElementById(elementOrId);
  }
  return elementOrId;
}

// data-table-scroll-key 付き一覧の横スクロール位置を sessionStorage に保存する
function saveTableScroll(elementOrId) {
  var el = tableScrollDomElement(elementOrId);
  if (!el) {
    return;
  }
  sessionStorage.setItem(tableScrollStorageKey(el), String(el.scrollLeft || 0));
}

// 保存した横スクロール位置を復元し、is-scroll-pending を外す（見つからなくても pending は解除する）
function restoreTableScroll(elementOrId) {
  var el = tableScrollDomElement(elementOrId);
  if (el) {
    var x = Number(sessionStorage.getItem(tableScrollStorageKey(el)) || 0);
    if (x > 0) {
      el.scrollLeft = x;
    }
    el.classList.remove("is-scroll-pending");
    return;
  }
  $(".table-responsive.is-scroll-pending").removeClass("is-scroll-pending");
}

function clearTableScroll(scrollKey) {
  if (!scrollKey) {
    return;
  }
  sessionStorage.removeItem(TABLE_SCROLL_STORAGE_PREFIX + scrollKey);
}

// 対象テーブルの scroll とソートクリックで位置を保存し、表示中の pending を復元する
function bindTableScrollPreserve(elementId) {
  var $targets = elementId ? $("#" + elementId) : $("[data-table-scroll-key]");
  if ($targets.length === 0) {
    $(".table-responsive.is-scroll-pending").removeClass("is-scroll-pending");
    return;
  }
  $targets.each(function() {
    var el = this;
    restoreTableScroll(el);
    $(el).off("scroll." + TABLE_SCROLL_EVENT_NS).on("scroll." + TABLE_SCROLL_EVENT_NS, function() {
      saveTableScroll(el);
    });
  });

  $(document).off("click." + TABLE_SCROLL_EVENT_NS, ".sort_button").on("click." + TABLE_SCROLL_EVENT_NS, ".sort_button", function() {
    $("[data-table-scroll-key]").each(function() {
      saveTableScroll(this);
    });
  });
}

$(function() {
  bindTableScrollPreserve();
  $(document).on("turbo:load." + TABLE_SCROLL_EVENT_NS + " turbo:frame-render." + TABLE_SCROLL_EVENT_NS, function() {
    bindTableScrollPreserve();
  });
});

if (typeof window !== "undefined") {
  window.restoreTableScroll = restoreTableScroll;
}

function tinyMceOnChangeHandler(form_name, id) {
  $("#"+id).html(tinymce.get(id).getContent());
  saveWebStorageFormHiddenValueNoRemove(id, form_name);
  $("#"+id).trigger("blueInputForm");
}

function showLoading() {
  $(document).off("click", ".sort_button");
  $(document).on("click", ".sort_button", function() {
    console.log("click");
    $(this).hide();
    $(this).siblings(".loading_image").show();
    return true;
  });
}

/**
 * 日付クリック時に入れる時刻。data-date-click-time に start または end を指定する。
 * 開始は 00:00:00、終了は 23:59:59。
 */
var datetimePickerClickTimes = {
  start: { hour: 0, minute: 0, second: 0 },
  end: { hour: 23, minute: 59, second: 59 }
};

/**
 * .rbase-datetimepicker を tempusdominus で初期化する。
 * simple_form の as: :datetime_picker が描く部品向け。RbaseController の connect から呼ぶ。
 * 他プロジェクトへの展開手順は docs/datetime_picker.md。
 */
function initDatetimePickers() {
  if (typeof $.fn.datetimepicker !== "function") {
    return;
  }
  $(".rbase-datetimepicker").each(function () {
    var $group = $(this);
    if ($group.data("datetimepicker")) {
      return;
    }
    var dateOnly = $group.hasClass("rbase-datepicker");
    $group.datetimepicker({
      format: dateOnly ? "YYYY/MM/DD" : "YYYY/MM/DD HH:mm:ss",
      locale: "ja",
      useCurrent: false,
      allowInputToggle: true,
      sideBySide: !dateOnly,
      toolbarPlacement: "bottom",
      buttons: { showToday: true, showClear: true, showClose: true },
      icons: {
        time: "bi bi-clock",
        date: "bi bi-calendar3",
        up: "bi bi-chevron-up",
        down: "bi bi-chevron-down",
        previous: "bi bi-chevron-left",
        next: "bi bi-chevron-right",
        today: "bi bi-calendar-check",
        clear: "bi bi-trash",
        close: "bi bi-check-lg"
      },
      tooltips: {
        today: "今日",
        clear: "削除",
        close: "OK",
        selectTime: "時刻",
        selectDate: "日付"
      }
    });
    // 削除で日付が空のまま閉じると _viewDate が消え、次の show が clone で落ちて二度と開かない
    var picker = $group.data("datetimepicker");
    var originalShow = picker.show;
    picker.show = function () {
      if (this._suppressShow) {
        return;
      }
      if (!this._viewDate) {
        this._viewDate = this.getMoment();
      }
      if (this.widget && this.widget[0] && (!this.widget.is(":visible") || this.widget[0].getBoundingClientRect().height === 0)) {
        this.widget.remove();
        this.widget = false;
      }
      return originalShow.apply(this, arguments);
    };
    // 削除は値を空にしたあとダイアログも閉じる。閉じた直後のフォーカスでは開き直さない
    $group[0].addEventListener("click", function (event) {
      var clearButton = event.target.closest && event.target.closest("[data-action='clear']");
      if (!clearButton || !$group[0].contains(clearButton)) {
        return;
      }
      event.preventDefault();
      event.stopPropagation();
      var current = $group.data("datetimepicker");
      if (!current) {
        return;
      }
      current._suppressShow = true;
      current.clear();
      current.hide();
      window.setTimeout(function () {
        current._suppressShow = false;
      }, 300);
    }, true);
    var dateClickTime = dateOnly ? null : datetimePickerClickTimes[$group.attr("data-date-click-time")];
    if (dateClickTime) {
      $group[0].addEventListener("click", function (event) {
        var dayCell = event.target.closest && event.target.closest("[data-action='selectDay']");
        if (!dayCell || !$group[0].contains(dayCell) || dayCell.classList.contains("disabled")) {
          return;
        }
        var currentBefore = $group.data("datetimepicker");
        var before = currentBefore && !currentBefore.unset ? currentBefore._getLastPickedDate() : null;
        var timeDiffersFromInitial = before && (
          before.hour() !== dateClickTime.hour ||
          before.minute() !== dateClickTime.minute ||
          before.second() !== dateClickTime.second
        );
        if (timeDiffersFromInitial) {
          return;
        }
        window.setTimeout(function () {
          var current = $group.data("datetimepicker");
          if (!current) {
            return;
          }
          var picked = current._getLastPickedDate();
          if (!picked) {
            return;
          }
          var next = picked.clone();
          next.hour(dateClickTime.hour);
          next.minute(dateClickTime.minute);
          next.second(dateClickTime.second);
          current._setValue(next, 0);
        }, 0);
      }, true);
    }
    // テキストへの貼り付けは yyyy/MM/dd。時刻は date-click-time の初期値
    $group.find(".datetimepicker-input").on("paste", function (event) {
      var clipboard = event.originalEvent && event.originalEvent.clipboardData;
      if (!clipboard) {
        return;
      }
      var text = $.trim(clipboard.getData("text"));
      if (!/^\d{4}\/\d{2}\/\d{2}$/.test(text)) {
        return;
      }
      event.preventDefault();
      var parsed = window.moment(text, "YYYY/MM/DD", true);
      if (!parsed.isValid()) {
        return;
      }
      if (!dateOnly) {
        var time = dateClickTime || datetimePickerClickTimes.start;
        parsed.hour(time.hour);
        parsed.minute(time.minute);
        parsed.second(time.second);
      }
      var current = $group.data("datetimepicker");
      if (current) {
        current.date(parsed);
      }
    });
  });
}

function defaultTinyMceOption() {
  return {
    promotion: false,
    cleanup: false,
    remove_linebreaks: false,
    valid_elements: '*[*]',
    extended_valid_elements: '*[*]',
    indent: true,
    wpautop: false,
    force_p_newlines: true
  }
}

module.exports = {
  admin_init: admin_init,
  restoreWebStorageFormValue: restoreWebStorageFormValue,
  restoreWebStorageFormValueWithLock: restoreWebStorageFormValueWithLock,
  restoreWebStorageFormValueWhenLoad: restoreWebStorageFormValueWhenLoad,
  restoreWebStorageFormValueNoTrigger: restoreWebStorageFormValueNoTrigger,
  lockFunc: lockFunc,
  getParams: getParams,
  showFormDisbaled: showFormDisbaled,
  showFormEnaled: showFormEnaled,
  getQueryField: getQueryField,
  saveWebStorageFormValue: saveWebStorageFormValue,
  saveWebStorageFormHiddenValue: saveWebStorageFormHiddenValue,
  trigger_only_visible: trigger_only_visible,
  clearWebStorageFormValue: clearWebStorageFormValue,
  disableWhenElementHide: disableWhenElementHide,
  initValueWebStorageFormValue: initValueWebStorageFormValue,
  resetTableXOffset: resetTableXOffset,
  saveTableXOffset: saveTableXOffset,
  restoreTableXOffset: restoreTableXOffset,
  saveTableScroll: saveTableScroll,
  restoreTableScroll: restoreTableScroll,
  bindTableScrollPreserve: bindTableScrollPreserve,
  clearTableScroll: clearTableScroll,
  tinyMceOnChangeHandler: tinyMceOnChangeHandler,
  showLoading: showLoading,
  defaultTinyMceOption: defaultTinyMceOption,
  initDatetimePickers: initDatetimePickers,
}
