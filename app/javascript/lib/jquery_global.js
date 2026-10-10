import jquery from "jquery"

window.$ = window.jQuery = jquery

jquery.ajaxPrefilter(function(options, originalOptions, xhr) {
  if (options.crossDomain) return
  var token = jquery('meta[name="csrf-token"]').attr("content")
  if (token) xhr.setRequestHeader("X-CSRF-Token", token)
})

export default jquery
