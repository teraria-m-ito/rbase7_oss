module Rbase
  #
  # Rbaseプラグインで本体の機能を拡張するためのモジュールです
  #
  module PluginModule
    class << self
      def target_to_plugins
        $target_to_plugins ||= {}
      end

      #
      # = プラグインの有無をチェックする
      #
      def is_available_plugin(plugin_name = nil)
        raise UsageError, "プラグイン名が設定されていません。" unless plugin_name
        Rbase::PluginModule.loaded_rbase_plugin_codes
        plugins = Rbase::PluginModule.target_to_plugins.values.flatten.map{|x| x.split('/')[1]}
        plugins.include?(plugin_name.to_s)
      end
      
      # 拡張用モジュールを登録します
      def register(*module_names)
        options = module_names.extract_options!
        module_names.each do |module_name|
          register_module(module_name, options)
        end
      end

      # 使われているRbaseプラグインのプラグインコード一覧を返す
      def loaded_rbase_plugin_codes
        $loaded_rbase_plugin_codes ||= set_loaded_rbase_plugin_codes
      end

      private
      
      def register_module(module_name, options)
        basename, mod_name = module_name.split(/::/, 2)
        plugin_name = basename.underscore
        target_name = mod_name.sub(/Ext$/, '')
        target_to_plugins[target_name] ||= []
        target_to_plugins[target_name] << plugin_name
      end

      private
      def set_loaded_rbase_plugin_codes
        rbase_plugins_config_path = File.expand_path(File.join(Rails.root, 'rbase_plugins.yml'))
        return [] unless File.exist?(rbase_plugins_config_path)

        rbase_plugins = Psych.load_file(rbase_plugins_config_path) || {}
        rbase_plugins.keys.map{|code| code.to_sym }
      end
    end

    #
    # Rbaseプラグインの状態によってテストの実行可否を制御するモジュールです
    #
    module RSpecExt
      # 指定されたRbaseプラグインが使われていたらテストをpendingにする
      def pending_if_loaded_plugin(code)
        unless Rbase::PluginModule.loaded_rbase_plugin_codes.include?(code)
          yield if block_given?
          return
        end
        message = "プラグイン(#{code})で機能が変更されているためpendingにします"
        block_given? ? pending(message){yield} : pending(message)
      end

      # 指定されたRbaseプラグインが使われていなかったらテストをpendingにする
      def pending_unless_loaded_plugin(code)
        if Rbase::PluginModule.loaded_rbase_plugin_codes.include?(code)
          yield if block_given?
          return
        end
        message = "プラグイン(#{code})が読み込まれていないためpendingにします"
        block_given? ? pending(message){yield} : pending(message)
      end

      # ec_adminでかつ指定されたRbaseプラグインがロードされている場合のみ、pendingにします。
      def pending_if_loaded_plugin_and_ec_admin(code)
        if block_given? && !(Rbase::PluginModule.loaded_rbase_plugin_codes.include?(code) && Rbase.config.ec_admin)
          return yield
        end
        return unless Rbase.config.ec_admin
        message = "プラグイン(#{code})で機能が変更されているため、ec_adminの場合のみpendingにします"
        block_given? ? pending(message){yield} : pending(message)
      end

      # ec_frontでかつ指定されたRbaseプラグインがロードされている場合のみ、pendingにします。
      def pending_if_loaded_plugin_and_ec_front(code)
        if block_given? && !(Rbase::PluginModule.loaded_rbase_plugin_codes.include?(code) && Rbase.config.ec_front)
          return yield
        end
        return unless Rbase.config.ec_front
        message = "プラグイン(#{code})で機能が変更されているため、ec_frontの場合のみpendingにします"
        block_given? ? pending(message){yield} : pending(message)
      end
    end

    #
    # プラグインで拡張されるクラス、モジュールにインクルードしておくモジュールです。
    # （ApplicationController、ApplicationHelper用）
    #
    # Extendable内の自動エイリアス機能が２重に実行されるとstack_trace_too_deepエラーが発生します。
    # そのためApplicationControllerのように他で継承されるようなクラスにはExtendableではなくIncludableを使ってください。
    # Extendableと違い、method_alias_chainは自動で貼られません。
    #
    module Includable
      def self.included(mod)
        plugins_names = Rbase::PluginModule.target_to_plugins[mod.name]
        Rails.logger.info "#{self.name}.included(#{mod.name}) => #{plugins_names.inspect}"
        return unless plugins_names
        return if plugins_names.empty?
        mod.instance_variable_set(:@available_plugin_names, plugins_names)
        plugins_names.each do |plugins_name|
          plugin_module = "#{plugins_name.camelize}::#{mod.name}Ext".constantize
          mod.module_eval{ include plugin_module }
        end
      end
    end

    #
    # プラグインで拡張されるクラス、モジュールにインクルードするモジュールです。
    # （通常のコントローラー、ヘルパー、モデル、ライブラリ用）
    #
    module Extendable
      def self.included(mod)
        plugins_names = Rbase::PluginModule.target_to_plugins[mod.name]
        Rails.logger.info "#{self.name}.included(#{mod.name}) => #{plugins_names.inspect}"
        return unless plugins_names
        return if plugins_names.empty?
        mod.instance_variable_set(:@available_plugin_names, plugins_names)
        plugins_names.each do |plugins_name|
          plugin_module = "::#{plugins_name.camelize}::#{mod.name}Ext".constantize
          mod.module_eval{ include plugin_module }
        end
        mod.extend(ClassMethods)
        mod.instance_eval do
          alias :method_added_without_rbase_plugin_module :method_added
          alias :method_added :method_added_with_rbase_plugin_module
          alias :singleton_method_added_without_rbase_plugin_module :singleton_method_added
          alias :singleton_method_added :singleton_method_added_with_rbase_plugin_module
        end
      end
      
      module ClassMethods
        def method_added_with_rbase_plugin_module(method_name)
          method_added_without_rbase_plugin_module(method_name)
          return if @instance_method_adding
          return unless @available_plugin_names
          @available_plugin_names.each do |plugin_name|
            aliased_target, punctuation = method_name.to_s.sub(/([?!=])$/, ''), $1
            if self.instance_methods.include?(:"#{aliased_target}_with_#{plugin_name}#{punctuation}")
              @instance_method_adding = true
              begin
                self.module_eval do
                  alias :"#{method_name}_without_#{plugin_name}" :"#{method_name}"
                  alias :"#{method_name}" :"#{method_name}_with_#{plugin_name}"
                  # alias_method_chain(method_name, plugin_name)
                end
              ensure
                @instance_method_adding = nil
              end
            end
          end
        end

        def singleton_method_added_with_rbase_plugin_module(method_name)
          singleton_method_added_without_rbase_plugin_module(method_name)
          return if @singleton_method_adding
          return unless @available_plugin_names
          @available_plugin_names.each do |plugin_name|
            aliased_target, punctuation = method_name.to_s.sub(/([?!=])$/, ''), $1
            if self.methods.include?(:"#{aliased_target}_with_#{plugin_name}#{punctuation}")
              @singleton_method_adding = true
              begin
                self.instance_eval <<-EOS
                  alias :#{method_name}_without_#{plugin_name} :#{method_name}
                  alias :#{method_name} :#{method_name}_with_#{plugin_name}
                EOS
              ensure
                @singleton_method_adding = nil
              end
            end
          end
        end
      end
    end

    module Migration
      class << self

        def call_migrations(migration_dir, method_name, options = {})
          options = {
            :schema_dump => true
          }.update(options || {})
          #SchemaComments.quiet = true
          files = Dir[File.join(migration_dir, '*.rb')]
          files.each{|filepath| require(filepath)}
          class_names = files.map{|filepath| File.basename(filepath, '.*').camelize}
          method_name == :up ? class_names.sort! : class_names.sort!{|a, b| b <=> a }
          if at_first = options[:at_first]
            at_first = [at_first] unless at_first.is_a?(Array)
            at_first = at_first.map{|name| name.to_s.camelize}
            at_first.reverse.each do |f|
              class_names.unshift(class_names.delete(f))
            end
          end
          if at_last = options[:at_last]
            at_last = [at_last] unless at_last.is_a?(Array)
            at_last = at_last.map{|name| name.to_s.camelize}
            at_last.each do |f|
              class_names << class_names.delete(f)
            end
          end
          class_names.each do |class_name|
            class_name.constantize.send(method_name)
          end
        end
      end
    end
  end
end

