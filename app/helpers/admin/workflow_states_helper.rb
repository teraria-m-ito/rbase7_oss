module Admin
  module WorkflowStatesHelper
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    def show_sort(m)
      result = ""
      result += link_to("<i class='fa fa-arrow-up'></i>".html_safe, 
        move_up_admin_workflow_workflow_state_path(@workflow, m), method: :get, class: "btn btn-default btn-sm", data: {turbo: true}) if m.display_order > 1
      result += link_to("<i class='fa fa-arrow-down'></i>".html_safe, 
        move_down_admin_workflow_workflow_state_path(@workflow, m), method: :get, class: "btn btn-default btn-sm", data: {turbo: true}) unless (WorkflowState.where(workflow_id: @workflow.id).maximum(:display_order)) == m.display_order
      result.html_safe
    end
  end
end
