require 'thinreports'

module Reports
  class BaseLogic
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
    include ActiveModel::Model

    attr_accessor :report_model # report
    
    # param report is report model
    def initialize(model = nil)
      self.report_model = model
    end
    
    def get_demo_preview
    end

    def get_preview(target_id)
      nil
    end
    
    def build_pdf(report = nil)
      report = ::Thinreports::Report.new(layout: File.join(Rails.root, 'public', self.report_model.report_attachments[0].document.url)) unless report
      report.start_new_page do |page|
        page.item(:text).value('Test')
      end
      report
    end
    
    def self.number_with_delimiter(number, *args)
      options = args.extract_options!
      options.symbolize_keys!

      defaults = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}

      unless args.empty?
        ActiveSupport::Deprecation.warn('number_with_delimiter takes an option hash ' +
          'instead of separate delimiter and precision arguments.', caller)
          delimiter = args[0] || defaults[:delimiter]
          separator = args[1] || defaults[:separator]
        end

        delimiter ||= (options[:delimiter] || defaults[:delimiter])
        separator ||= (options[:separator] || defaults[:separator])

      begin
        parts = number.to_s.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
        parts.join(separator)
      rescue
      number
      end
    end    
  end
end