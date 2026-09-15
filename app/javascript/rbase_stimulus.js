import "./lib/jquery_global"
import { Controller } from "@hotwired/stimulus"
import * as Rbase from "./rbase_common.js"

/** gem 等のサブパスから @hotwired/stimulus を直接 import すると esbuild が解決できないため再エクスポートする */
export { Controller }

var currentControllernameValue = null;
var currentActionnameValue = null;

export class RbaseController extends Controller {
  static values = {
    controllername: String,
    actionname: String,
    params: Object,
    callFrom: String
  }
  
  connect() {
    var preview = document.documentElement.hasAttribute("data-turbo-preview");

    //Turboによって、キャッシュロードと実ロードで2回呼ばれるので、キャッシュロード時はスキップする
    console.log("---------------------------");
    console.log("[RbaseController]connected()");
    console.log("[RbaseController]preview:"+preview);

    if (preview) {
      return false;
    }

    // Turbo 遷移後に Bootstrap モーダルの backdrop が残留すると、画面全体のクリックが遮断される
    document.querySelectorAll(".modal-backdrop").forEach(function(el) {
      el.remove();
    });
    if (document.body.classList.contains("modal-open")) {
      document.body.classList.remove("modal-open");
      document.body.style.removeProperty("padding-right");
    }

    console.log("[RbaseController]currentControllernameValue:"+currentControllernameValue);
    console.log("[RbaseController]currentActionnameValue:"+currentActionnameValue);
    
    $('.datepicker').datepicker({
      format: 'yyyy/mm/dd',
      language: 'ja',
      autoclose: true,
      todayHighlight: true
    });
    
    var $this = $(this);
    var self = this;
    var controllername = this.controllernameValue;
    var actionnameValue = this.actionnameValue;
    var defer = new $.Deferred().resolve();

    // jquery-treeview: sync 後は Turbo Stream.replace で DOM だけ入れ替えられ、
    // turbo:frame-load は飛ばない。turbo:load や子 DOM 挿入で掛け直す。
    var reinitJqueryTreeview = function() {
      if ($(".treeview").length) {
        $(".treeview").each(function() {
          self.destroyTreeview($(this));
        });
        $(".treeview").treeview();
      }
      $(".loading_image-small").hide();
    };
    // flash は entry-turbo-message 内のほか、turbo_stream.replace("entry-common-message") 後も
    // #entry-common-message 配下に載る。Stream 適用は connect より後のため、描画後に再スケジュールする。
    var autoDismissFlashMessages = function() {
      var $alerts = $("#entry-common-message .alert, #entry-turbo-message .alert");
      if (!$alerts.length) {
        return;
      }
      setTimeout(function() {
        $alerts.each(function() {
          var $a = $(this);
          if ($a.closest("body").length) {
            $a.alert("close");
          }
        });
      }, 5000);
    };
    var scheduleFlashAutoDismiss = function() {
      setTimeout(function() {
        autoDismissFlashMessages();
      }, 100);
    };
    var reinitJqueryTreeviewDebounced = (function() {
      var t = null;
      return function() {
        if (t) { clearTimeout(t); }
        t = setTimeout(function() {
          t = null;
          reinitJqueryTreeview();
        }, 20);
      };
    })();

    var param = location.search
    var selfRedirectValue = false;
    if (param.indexOf("self_redirect=true") >= 0) {
      selfRedirectValue = true;
    }

    defer.promise().done(function() {
      if (currentControllernameValue != controllername || currentActionnameValue != actionnameValue || selfRedirectValue) {
        console.log("call:" + controllername + "/" + actionnameValue);
        currentControllernameValue = controllername;
        
        switch(actionnameValue) {
          case "create":
            actionnameValue = "new";
            break;
          case "update":
            actionnameValue = "edit";
            break;
        }
        
        currentActionnameValue = actionnameValue;
        self.callFromValue = "normal";
        $this.trigger(actionnameValue);
      } else {
        console.log("deterrence:" + controllername + "/" + actionnameValue);
        reinitJqueryTreeview();
      }
      autoDismissFlashMessages();
    });

    //ターボで更新した場合もイベント呼出を行う。
    $(document).off("turbo:before-fetch-response");
    $(document).on("turbo:before-fetch-response", function(event) {
      console.log("[RbaseController]call turbo:before-fetch-response");
      // 303 追跡後は最終レスポンス（例: 200）のみ届くためヘッダが無いことが多い。無い場合は何もしない。
      var rawHeader = event.detail.fetchResponse.header("X-Flash-Messages");
      if (!rawHeader || rawHeader === "null" || rawHeader === "") {
        return;
      }
      var json;
      try {
        json = JSON.parse(rawHeader);
      } catch (e) {
        console.warn("[RbaseController] X-Flash-Messages JSON parse error", e);
        return;
      }
      var decodeFlashPart = function (encoded) {
        try {
          return decodeURIComponent(String(encoded).replace(/\+/g, " "));
        } catch (e2) {
          return String(encoded);
        }
      };
      var message = "";
      var both = "";
      if (json) {
        if (json["notice"] && json["alert"]) {
          both = "show_alert_both";
        }
        if (json["notice"]) {
          if (!Array.isArray(json["notice"])) {
            json["notice"] = [json["notice"]];
          }
          $.each(json["notice"], function (index, val) {
            var text = decodeFlashPart(val);
            console.log("[RbaseController][notice]" + text);
            message = message + "<div class=\"alert alert-success alert-dismissible fade show " + both + "\" role=\"alert\">" + text;
            message = message + " \
  <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">\
    <span aria-hidden=\"true\">&times;</span>\
  </button>\
</div>"
          });
        }
        if (json["alert"]) {
          if (!Array.isArray(json["alert"])) {
            json["alert"] = [json["alert"]];
          }
          $.each(json["alert"], function (index, val) {
            var text = decodeFlashPart(val);
            console.log("[RbaseController][alert]" + text);
            message = message + "<div class=\"alert alert-danger alert-dismissible fade show\" role=\"alert\">" + text;
            message = message + " \
  <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">\
    <span aria-hidden=\"true\">&times;</span>\
  </button>\
</div>"
          });
        }
        if (message != "") {
          $("#entry-turbo-message").html(message);
          autoDismissFlashMessages();
        }
      }
    });
    
    $(document).off("turbo:before-stream-render");
    console.log("[RbaseController]add turbo:before-stream-render");
    $(document).on("turbo:before-stream-render", function() {
      //同一URLをロードした時にこのイベントが呼ばれる為、clear=trueのパラメータは削除する
      var url = window.location.pathname;
      var params = window.location.search;
      params = params.replace("clear=true", "");

      if (params.length > 1) {
        url = url + params;
      }

      history.replaceState("", "", url);

      currentControllernameValue = controllername;
      switch(actionnameValue) {
        case "create":
          actionnameValue = "new";
          break;
        case "update":
          actionnameValue = "edit";
          break;
      }
      currentActionnameValue = actionnameValue;
      self.callFromValue = "before-stream-render";
      console.log("catch turbo:before-stream-render:"+controllername+"/"+actionnameValue);
      console.log("turbo:before-stream-render call:"+controllername+"/"+actionnameValue);

      $this.trigger(actionnameValue);
      // Stream の DOM 反映はこのイベントの非同期処理の後。flash 自動消去を描画後に掛け直す
      scheduleFlashAutoDismiss();
    });

    $(document).off("turbo:frame-render.rbaseFlashDismiss");
    $(document).on("turbo:frame-render.rbaseFlashDismiss", function(ev) {
      var id = ev.target && ev.target.id;
      if (id === "entry-common-message" || id === "entry-turbo-message") {
        scheduleFlashAutoDismiss();
      }
    });

    console.log("[RbaseController]add turbo:frame-load");
    $(document).off("turbo:frame-load");
    $(document).on("turbo:frame-load", function(event) {
      console.log("!!!!!!!!!!!!!!!!turbo:frame-load");
      $(document).trigger("turbo:before-stream-render");
      reinitJqueryTreeview();
    });

    var onTurboLoadOrRender = function() {
      reinitJqueryTreeviewDebounced();
      scheduleFlashAutoDismiss();
    };
    $(document).off("turbo:load.rbaseTreeAndFlash").off("turbo:render.rbaseTreeAndFlash");
    $(document).on("turbo:load.rbaseTreeAndFlash", onTurboLoadOrRender);
    $(document).on("turbo:render.rbaseTreeAndFlash", onTurboLoadOrRender);

    if (typeof window.MutationObserver !== "undefined") {
      var treeviewRoot = document.querySelector("section.content") || document.querySelector(".content .container-fluid") || document.body;
      if (treeviewRoot) {
        this._rbaseTreeviewObserver = new MutationObserver(function(mutations) {
          for (var k = 0; k < mutations.length; k++) {
            var m = mutations[k];
            for (var n = 0; n < m.addedNodes.length; n++) {
              var el = m.addedNodes[n];
              if (el.nodeType !== 1) { continue; }
              if (el.classList && el.classList.contains("treeview")) {
                reinitJqueryTreeviewDebounced();
                return;
              }
              if (el.id === "entry-turbo-account_search_results" || (el.id && el.id.indexOf("entry-turbo-") === 0)) {
                reinitJqueryTreeviewDebounced();
                return;
              }
              if (el.querySelector && el.querySelector(".treeview, turbo-frame#entry-turbo-account_search_results")) {
                reinitJqueryTreeviewDebounced();
                return;
              }
            }
          }
        });
        this._rbaseTreeviewObserver.observe(treeviewRoot, { childList: true, subtree: true });
      }
    }
    
    console.log("set tooltip");
    $('[data-toggle="tooltip"]').tooltip({
      trigger: 'click',
      placement: 'top',
      boundary: 'window',
      container: 'body',
      html: true,
      sanitize: false
    });
    
    $(document).off('click.tooltipClose');
    $(document).on('click.tooltipClose', function (e) {
      if ($(e.target).closest('[data-toggle="tooltip"], .tooltip').length) {
        return;
      }
      var $opened = $('[data-toggle="tooltip"][aria-describedby]');
      if ($opened.length) {
        $opened.tooltip('hide');
      }
    });

    
    $(".selectpicker").selectpicker({
      noneSelectedText: "Please select.",
      liveSearch: true,
      liveSearchPlaceholder: "Search by prefix match.",
      liveSearchStyle: 'startWith'
    });
    $(document).off("change", ".selectpicker");
    $(document).on("change", ".selectpicker", function(event) {
      console.log("change:" + $(event.target).prop("id"));
      $(".selectpicker").selectpicker("refresh");
    })

    $(document).off("changed.bs.select", ".selectpicker");
    $(document).on("changed.bs.select", ".selectpicker", function(event) {
      console.log("changed.bs.select:" + $(event.target).prop("id"));
    })
    
    
    var externalWin = null;
    var NAME = 'external_tab';
    
    //ポップアップは単位とする為の処理
    $(document).off("click.externalLink", "a.external-link");
    $(document).on("click.externalLink", "a.external-link", function(e) {
      if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;
      // jQuery click eventでは button が未定義のブラウザがあるため which で判定する
      if (e.which && e.which !== 1) return;
      
      e.preventDefault();
      
      var url = $(this).attr("href");
      if (!url) return;
      
      if (!externalWin || externalWin.closed) {
        externalWin = window.open(url, NAME);
        if (!externalWin) {
          // ポップアップブロック時のフォールバック
          window.location.href = url;
        }
        return;
      }
      try {
        externalWin.location.href = url;
        externalWin.focus();
      } catch (_e) {
        externalWin = window.open(url, NAME);
      }
    });

    console.log("[RbaseController]after currentControllernameValue:"+currentControllernameValue);
    console.log("[RbaseController]after currentActionnameValue:"+currentActionnameValue);
    
    if ($("#google_translate_element").length) {
      (async () => {
        await Rbase.loadGoogleTranslate();
        console.log("[RbaseController]after call loadGoogleTranslate");
        new google.translate.TranslateElement({
              pageLanguage: 'ja',
              includedLanguages: 'en,zh-CN',
              layout: google.translate.TranslateElement.InlineLayout.SIMPLE
            }, 'google_translate_element'
        );
      })();
    }
  }
  
  index() {
    console.log("index()");
  }
  
  new() {
    console.log("new()");
  }
  
  create() {
    console.log("create() => new()");
    this.new();
  }
  
  edit() {
    console.log("edit()");
  }

  update() {
    console.log("update() => edit()");
    this.edit();
  }

  show() {
    console.log("show()");
  }
  
  destroyTreeview($tree) {
    $tree.find(".hitarea").remove();
    $tree.find("li").removeClass(
        "collapsable expandable lastCollapsable lastExpandable open closed"
    );
    
    $tree.find("ul").removeAttr("style");
    $tree.off();
  }
}