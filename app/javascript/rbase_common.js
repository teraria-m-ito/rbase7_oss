require("./lib/jquery_global")

function admin_init() {
  $(function() {
  });
}

function restoreWebStorageFormValue(model_name) {
  $(function() {
    for(key in localStorage) {
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
      input = $(this);
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
      input = $(this);
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
    for(key in localStorage) {
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
      input = $(this);
      if (!input.hasClass("no-restore")) {
        val = localStorage.getItem(model_name + '/' + input.prop('id'));
        if (val != null) {
          if (input.prop('type') == 'checkbox') {
            input.prop('checked', (val == 'true'));
          }
          if (input.prop('type') == 'radio') {
            //ラジオボタンの場合、IDを削除したキーで保存しているので復元してcheckを入れる
            ids = input.prop('id').split("_");
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
      input = $(this);
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
      input = $(this);
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
      input = $(this);
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
  url = location.href;
  parameters = url.split("?");
  if (parameters.length <= 1) {
    return null;
  }
  params  = parameters[1].split("&");
  paramsArray = [];
  for ( i = 0; i < params.length; i++ ) {
    neet = params[i].split("=");
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
  for(key in localStorage) {
    if (key.indexOf(model_name+"/") != -1) {
      delete localStorage[key];
    }
  }
}

function disableWhenElementHide(element_class) {
  var targets = $("."+element_class+":hidden");
  targets.each(function() {
    targers = $(this).find("input,select,textarea");
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
    targers = $(this).find("input,select,textarea");
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

function loadGoogleTranslate() {
  return new Promise((resolve, reject) => {
    window.googleTranslateElementInit = () => {
      resolve();
    };
    
    const script = document.createElement('script');
    script.src = 'https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
    script.async = true;
    script.onerror = (e) => reject(e);
    
    document.head.appendChild(script);
  });
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
  loadGoogleTranslate: loadGoogleTranslate,
}
