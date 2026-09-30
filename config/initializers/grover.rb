# frozen_string_literal: true

Grover.configure do |config|
  config.node_env_vars = { 'TMPDIR' => '/tmp' }
  config.options = {
    format: 'A4',
    margin: {
      top: '5mm',
      left: '5mm',
      right: '5mm',
      bottom: '5mm'
    },
    viewport: {
      width: 1280,
      height: 960
    },
    prefer_css_page_size: true,
    emulate_media: 'print',
    cache: false,
    # timeout: 300000,
    responsive: false,
    display_url: ENV["EPORTFOLIO_HOST"],
    launch_args: ['--font-render-hinting=medium', '--lang=ja'],
    wait_for_function: 'typeof window.printReady === "undefined" || window.printReady === 0',
    # wait_until: 'networkidle0',
    wait_until: 'load',
    timeout: 0,
    request_timeout: 0,
    scale: 0.75,
    # debug: {
    #   headless: true,
    #   devtools: false
    # }
  }
end