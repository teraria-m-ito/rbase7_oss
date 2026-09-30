module Admin
  module RolesHelper
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
    def controller_display_name(controller_name)
      RoleAction.where(controller_name: controller_name).first.try(:display_name)
    end

    def controller_display_name_desc(controller_name)
      controller_path = RoleAction.where(controller_name: controller_name).first.try(:controller_path)
      l =<<EOS
                    <span rel="tooltip"
                      data-toggle="tooltip"
                      data-placement="auto"
                      data-html="true"
                      title="#{controller_path}">
                      <i class="fa-solid fa-circle-question"></i>
                    </span>
EOS
      l.html_safe
    end
  end
end
