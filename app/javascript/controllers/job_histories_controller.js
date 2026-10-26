import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"
import { get, post, put, patch, destroy } from '@rails/request.js'


const SEARCH_FORM_NAME = 'job_manages/search_conditions';
const FORM_NAME = 'job_manage';
const JOB_HISTORY_SEARCH_RESULTS_FRAME_ID = "entry-turbo-job_history_search_results";
const JOB_HISTORY_LIST_POLL_MS = 5000;

var jobHistoryListPollTimer = null;
var jobHistoryListFrameLoadBound = false;

const jobHistorySearchResultsFrame = function () {
  return document.getElementById(JOB_HISTORY_SEARCH_RESULTS_FRAME_ID);
};

/** 表示中の一覧に処理待ち（wait）または処理中（processing）の行があるか */
const jobHistoryListHasProcessing = function () {
  var frame = jobHistorySearchResultsFrame();
  if (!frame || !frame.dataset) {
    return false;
  }
  return frame.dataset.hasProcessing === "true";
};

const stopJobHistoryListPoll = function () {
  if (jobHistoryListPollTimer) {
    clearInterval(jobHistoryListPollTimer);
    jobHistoryListPollTimer = null;
  }
};

/**
 * ポーリング用: フレーム HTML を取得し、行構成が同じならセル差分だけ反映する。
 * 全体差し替えを避けることで点滅を抑える。
 */
const applyJobHistoryListHtml = function (html) {
  var parser = new DOMParser();
  var doc = parser.parseFromString(html, "text/html");
  var newFrame =
    doc.getElementById(JOB_HISTORY_SEARCH_RESULTS_FRAME_ID) ||
    doc.querySelector("turbo-frame");
  var oldFrame = jobHistorySearchResultsFrame();
  if (!newFrame || !oldFrame) {
    return;
  }

  if (newFrame.dataset && typeof newFrame.dataset.hasProcessing !== "undefined") {
    oldFrame.dataset.hasProcessing = newFrame.dataset.hasProcessing;
  }

  var $oldRows = $(oldFrame).find("tbody tr[data-job-history-id]");
  var $newRows = $(newFrame).find("tbody tr[data-job-history-id]");
  var oldIds = $oldRows
    .map(function () {
      return this.getAttribute("data-job-history-id");
    })
    .get()
    .join(",");
  var newIds = $newRows
    .map(function () {
      return this.getAttribute("data-job-history-id");
    })
    .get()
    .join(",");

  if (oldIds === newIds && $oldRows.length > 0) {
    $newRows.each(function () {
      var id = this.getAttribute("data-job-history-id");
      var oldRow = oldFrame.querySelector(
        'tr[data-job-history-id="' + id + '"]'
      );
      if (!oldRow) {
        return;
      }
      var newCells = this.children;
      var oldCells = oldRow.children;
      var i;
      for (i = 0; i < oldCells.length && i < newCells.length; i++) {
        if (oldCells[i].innerHTML !== newCells[i].innerHTML) {
          oldCells[i].innerHTML = newCells[i].innerHTML;
        }
      }
    });
    return;
  }

  oldFrame.innerHTML = newFrame.innerHTML;
};

const fetchJobHistoryListFrame = function () {
  return fetch(window.location.href, {
    headers: {
      Accept: "text/html",
      "Turbo-Frame": JOB_HISTORY_SEARCH_RESULTS_FRAME_ID,
    },
    credentials: "same-origin",
  }).then(function (response) {
    if (!response.ok) {
      throw new Error("job history list poll failed");
    }
    return response.text();
  });
};

/** 処理待ち／処理中の行があるときだけ、検索結果を 5 秒周期で差分更新する */
const startJobHistoryListPoll = function () {
  if (jobHistoryListPollTimer) {
    return;
  }
  if (!jobHistoryListHasProcessing()) {
    return;
  }
  jobHistoryListPollTimer = setInterval(function () {
    if (!jobHistoryListHasProcessing()) {
      stopJobHistoryListPoll();
      return;
    }
    fetchJobHistoryListFrame()
      .then(function (html) {
        applyJobHistoryListHtml(html);
        refreshJobHistoryListPoll();
      })
      .catch(function () {
        // 通信失敗時は次回ポーリングに任せる
      });
  }, JOB_HISTORY_LIST_POLL_MS);
};

const refreshJobHistoryListPoll = function () {
  if (jobHistoryListHasProcessing()) {
    startJobHistoryListPoll();
  } else {
    stopJobHistoryListPoll();
  }
};

const bindJobHistoryListFrameLoad = function () {
  if (jobHistoryListFrameLoadBound) {
    return;
  }
  jobHistoryListFrameLoadBound = true;
  document.addEventListener("turbo:frame-load", function (event) {
    if (!event.target || event.target.id !== JOB_HISTORY_SEARCH_RESULTS_FRAME_ID) {
      return;
    }
    refreshJobHistoryListPoll();
  });
};

export default class extends RbaseController {
  disconnect() {
    stopJobHistoryListPoll();
    super.disconnect();
  }

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

    // 表示中に処理待ち／処理中の行があれば、検索結果だけ 5 秒周期で更新する
    bindJobHistoryListFrameLoad();
    refreshJobHistoryListPoll();
  }
  
  show() {
    super.show();
    Rbase.showFormDisbaled();
  }
}
