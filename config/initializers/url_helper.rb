module ActionView
  module Helpers
    module UrlHelper

      alias_method :link_to_origin, :link_to
      def link_to(name = nil, options = nil, html_options = {}, &block)
        unless html_options.has_key?(:data)
          html_options = html_options.merge({data: {turbo: false}})
        else
          if html_options[:data].to_h.has_key?(:turbo_confirm) || html_options[:data].to_h.has_key?(:turbo_method)
          elsif html_options[:data].to_h.has_key?(:turbo)
          else
            html_options[:data][:turbo] = false
          end
        end
        link_to_origin(name, options, html_options, &block)
      end
    end
  end
end