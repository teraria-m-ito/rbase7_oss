// Entry point for the build script in your package.json
// jquery_global を先頭で import し、他モジュール評価前に window.$ を載せる
import jquery from "./lib/jquery_global"
import "@hotwired/turbo-rails"

import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

var _tooltip = jQuery.fn.tooltip;
require("jquery-ui-dist/jquery-ui")
jQuery.fn.tooltip = _tooltip;

require("jquery-treeview/jquery.treeview")

require("moment/min/moment.min")
require("moment/locale/ja")

require("form-serializer/dist/jquery.serialize-object.min")

require("bootstrap-datepicker")
require("bootstrap-datepicker/dist/locales/bootstrap-datepicker.ja.min")

require("bootstrap-select/dist/js/bootstrap-select.min")

require("select2")(window, jquery)
require("select2/dist/js/i18n/ja")

require("bootstrap4-toggle/js/bootstrap4-toggle.min")

// require("blueimp-file-upload/js/jquery.iframe-transport.js")
// require("blueimp-file-upload/js/jquery.fileupload.js")
// require("blueimp-file-upload/js/jquery.fileupload-process.js")
// require("blueimp-file-upload/js/jquery.fileupload-image.js")
// require("blueimp-file-upload/js/jquery.fileupload-audio.js")
// require("blueimp-file-upload/js/jquery.fileupload-video.js")
// require("blueimp-file-upload/js/jquery.fileupload-validate.js")
// require("blueimp-file-upload/js/jquery.fileupload-ui.js")

// import "admin-lte/plugins/bootstrap/js/bootstrap.bundle.min"

import Chart from "chart.js/auto";
// 親コンテナ（message_area / GridStack セル等）の枠いっぱいに描画する（既定 true だと横長のレターボックスになりやすい）
Chart.defaults.maintainAspectRatio = false;
window.Chart = Chart;
import ChartDataLabels from 'chartjs-plugin-datalabels';
window.ChartDataLabels = ChartDataLabels;

import { BoxPlotController, BoxAndWiskers } from '@sgratzl/chartjs-chart-boxplot';
Chart.register(BoxPlotController, BoxAndWiskers);

require("jquery.cookie/jquery.cookie.js")

import "admin-lte/dist/js/adminlte.min"
import "@fortawesome/fontawesome-free/js/all"

import * as Rbase from "./rbase_common.js"

import Widget from "./widget_common.js"
window.Widget = Widget;


// for widgets

// controller
import "./controllers"

