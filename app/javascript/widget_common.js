const COLOR = {
  "red": "rgb(255, 99, 132)",
  "orange": "rgb(255, 159, 64)",
  "yellow": "rgb(255, 205, 86)",
  "green": "rgb(75, 192, 192)",
  "blue": "rgb(54, 162, 235)",
  "purple": "rgb(153, 102, 255)",
  "grey": "rgb(201, 203, 207)",
  "darkgrey": "rgb(101, 103, 107)",
  "hotpink": "rgb(255, 105, 180)",
  "coral": "rgb(255, 127, 80)",
  "lightyellow": "rgb(255, 255, 224)",
  "greenyellow": "rgb(173, 255, 47)",
  "lightblue": "rgb(173, 216, 230)",
  "amethyst": "rgb(153,102,204)",
  "black": "rgb(0,0,0)",
  "aliceblue": "rgb(75, 180, 120)"
};

const COLOR_keys = Object.keys(COLOR);

const COLOR_OPTICS = {
  "red": "rgba(255, 99, 132, 0.2)",
  "orange": "rgba(255, 159, 64, 0.2)",
  "yellow": "rgba(255, 205, 86, 0.2)",
  "green": "rgba(75, 192, 192, 0.2)",
  "blue": "rgba(54, 162, 235, 0.2)",
  "purple": "rgba(153, 102, 255, 0.2)",
  "grey": "rgba(201, 203, 207, 0.2)",
  "darkgrey": "rgba(101, 103, 107, 0.2)",
  "hotpink": "rgba(255, 105, 180, 0.2)",
  "coral": "rgba(255, 127, 80, 0.2)",
  "lightyellow": "rgba(255, 255, 224, 0.2)",
  "greenyellow": "rgba(173, 255, 47, 0.2)",
  "lightblue": "rgba(173, 216, 230, 0.2)",
  "amethyst": "rgba(153,102,204, 0.2)",
  "aliceblue": "rgba(75, 180, 120, 0.2)"
};

const COLOR_OPTICS_keys = Object.keys(COLOR_OPTICS);

const COLOR_MAP = COLOR_keys.map(function (v) {return COLOR[v];});
const COLOR_OPTICS_MAP = COLOR_OPTICS_keys.map(function (v) {return COLOR_OPTICS[v];});

function idGenerate() {
  var len = 8;
  var str = "abcdefghijklmnopqrstuvwxyz";
  var strLen = str.length;
  var result = "";
  
  for (var i = 0; i < len; i++) {
    result += str[Math.floor(Math.random() * strLen)];
  }
  return result;
}

function showAllDatasets(chart) {
  chart.data.datasets.forEach(function (ds) {
    ds.hidden = false;
  })
}

function hideSelectDatasets(chart, index) {
  for (var i = 0; i < chart.data.datasets.length; i++) {
    chart.data.datasets[i].hidden = i != index;
  }
}

function splitLabelName(label, len) {
  if (label.length <= len) {
    return label;
  } else {
    let nameArr = [];
    for (let i = 0; i < label.length; i += len) {
      nameArr.push(label.substring(i, i + len));
    }
    return nameArr;
  }
}

function previousYearPeriod(date = new Date()) {
  const m = date.getMonth() + 1; // 1-12
   if (m <= 3) {
     return date.getFullYear() - 1;
   } else {
     return date.getFullYear();
   }
}

function ensurePrintReadyFallback() {
  if (typeof window.printReady === "undefined") {
    window.printReady = 0;
  }
}

function startWidgetUpdates() {
  if (window.printReady == undefined) {
    window.printReady = 1;
  } else {
    window.printReady = window.printReady + 1;
  }
  console.log("[startWidgetUpdates]img.loading window.printReady :" + window.printReady );
}

function waitWidgetUpdates() {
  setTimeout(function() {
    window.printReady = window.printReady - 1;
    console.log("[waitWidgetUpdates]img.loading window.printReady :" + window.printReady );
    if (window.printReady == 0) {
      if ($("#current_lms_user_id").children("div#widget_updated").length == 0) {
        console.log("img.loading added...");
        $("#current_lms_user_id").append("<div id='widget_updated'>done</div>");
      }
    }
  }, 3000);
}

module.exports = {
  COLOR: COLOR,
  COLOR_MAP: COLOR_MAP,
  COLOR_OPTICS: COLOR_OPTICS,
  COLOR_OPTICS_MAP: COLOR_OPTICS_MAP,
  idGenerate: idGenerate,
  showAllDatasets: showAllDatasets,
  hideSelectDatasets: hideSelectDatasets,
  splitLabelName: splitLabelName,
  previousYearPeriod: previousYearPeriod,
  ensurePrintReadyFallback: ensurePrintReadyFallback,
  startWidgetUpdates: startWidgetUpdates,
  waitWidgetUpdates: waitWidgetUpdates,
}

