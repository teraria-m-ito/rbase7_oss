class IssuesController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_select_fields, only: [:index, :show, :new, :create, :edit, :update]
  before_action :set_assgins, only: [:show, :new, :create, :edit, :update]
  before_action :set_workflow_states, only: [:change_issue_type_for_index, :change_issue_type_for_new_or_edit]

  before_action :set_issue_custom_fields, only: [:show, :edit]
  before_action :set_fields, only: [:show, :new, :create, :edit, :update]

  include RenderFilter

#  before_render :set_workflow_states_for_index, only: [:index]
  before_render :set_issue_custom_fields, only: [:new]
  
  respond_to :html
  def index
    @target_class = "issues/search_conditions"

    if params[:issues_search_conditions]
      @condition = ::Issues::SearchConditions.new(search_condition_params)

      #ActiveModelはvalid?後にto_yamlを行うとエラーになるので、一旦、退避したインスタンスで評価する
      tmp_condition = @condition.dup
      return render 'index' unless tmp_condition.valid?
      session[:issues_condition] = @condition.to_yaml

      @query_fields = Psych.safe_load(session[:query_fields])
      remove_uncheck_condition
      @selected_query_fields = Psych.safe_load(session[:selected_query_fields], permitted_classes: [::Issues::SearchConditions])

      @issues = @condition.search.page(params[:page])
    else
      if session[:issues_condition]
        @condition =  Psych.safe_load(session[:issues_condition], permitted_classes: [::Issues::SearchConditions])
        @query_fields = Psych.safe_load(session[:query_fields])

        remove_uncheck_condition
        @issues = @condition.search.page(params[:page])
        @queries = (Query.owns(current_admin_user.id, 'issues/search_conditions') + Query.shares('issues/search_conditions')).uniq
        
        @selected_query_fields = Psych.safe_load(session[:selected_query_fields])
      else
        @condition = ::Issues::SearchConditions.new
        @query_fields = ::Issues::SearchConditions.condition_field_type_options

        #@selected_query_fields = [@query_fields.shift] #先頭を取得する
        @selected_query_fields = ::Issues::SearchConditions.default_conditions
        @query_fields.shift
        session[:issues_condition] = @condition.to_yaml
        session[:query_fields] = @query_fields.to_yaml
        session[:selected_query_fields] = @selected_query_fields.to_yaml

        @issues = @condition.search.page(params[:page])
      end
    end

    @stimulus_params = {
      url1: select_field_queries_path,
      url2: queries_path,
      data_type: "issues/search_conditions"
    }.to_json
    
  end

  def show
    @workflow_states = @issue.workflow_state.workflow.workflow_states
    
    respond_with(@issue)
  end

  def new
    @issue = Issue.new
    session[:issue] = @issue.id
    @workflow_states = []
    
    @stimulus_params = {
      url: change_issue_type_for_new_or_edit_issues_path
    }.to_json
  end

  def edit
    session[:issue] = @issue.id
    @issue_types = IssueType.joins(:issue_type_sites).where("issue_type_sites.site_id IN (?)", session[:active_site_id])
    @workflow_states = @issue.aviable_workflow_states(current_admin_user)

    @stimulus_params = {
      url: change_issue_type_for_new_or_edit_issues_path
    }.to_json
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.site_id = session[:active_site_id]
    @issue.current_admin_user = current_admin_user #ToDo
    @workflow_states = @issue.aviable_workflow_states(current_admin_user)

    if @issue.save
      @issue.invoke
      flash[:notice] = t("views.common.create_complete_message")
      redirect_to issues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Issue.transaction do
      @issue.assign_attributes(issue_params)
      @issue.current_admin_user = current_admin_user #ToDo
      @workflow_states = @issue.aviable_workflow_states(current_admin_user)

      if @issue.save
        @issue.invoke
        flash[:notice] = t("views.common.update_complete_message")
        redirect_to issues_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @issue.current_admin_user = current_admin_userit
    flash[:notice] = t("views.common.destroy_complete_message") if @issue.destroy
    respond_with(@issue, location: issues_url)
  end
    
  desc :auth_as => :index
  def change_issue_type_for_index
    @condition = session[:issues_condition].nil? ? ::Issues::SearchConditions.new : Psych.safe_load(session[:issues_condition])
  end

  desc :auth_as => :new
  def change_issue_type_for_new_or_edit
    @issue = session[:issue].present? ? ::Issue.find(session[:issue]) : ::Issue.new
    @issue.issue_type_id = params[:issue_type_id]
    @workflow_states = @issue.new_record? ? WorkflowState.prohabbits_site(session[:active_site_id]) : @issue.aviable_workflow_states(current_admin_user)
  end
  private

  def set_workflow_states
    unless params[:issue_type_id].blank?
      issue_type = IssueType.find(params[:issue_type_id])
      path =  Rails.application.routes.recognize_path(request.referrer)
      if path[:action] == 'new'
        @workflow_states = issue_type.workflow_states.start_points
      elsif path[:action] == 'edit'
      else
        @workflow_states = issue_type.workflow_states
      end
      
    else
      @workflow_states = []
    end
  end

  def set_issue
    @issue = Issue.find(params[:id])
  end
  
  def set_select_fields
#    @issue_types = IssueType.user_prohabbits(current_admin_user).all
    @field_list = {
      workflow_state_id: WorkflowState.prohabbits_site(session[:active_site_id]),
      issue_type_id: IssueType.all,
      creator_id: AdminUser.define_site(current_admin_user.selected_site).all,
      assigned_id: AdminUser.define_site(current_admin_user.selected_site).all
      }
  end
  
  def set_assgins
    @assigns = AdminUser.user_prohabbits(current_admin_user).all    
  end

  def set_workflow_states_for_index
    @workflow_states = @condition.issue_type_id.blank? ? [] : IssueType.find(@condition.issue_type_id).workflow_states
  end

  def search_condition_params
    params.require(:issues_search_conditions).permit!
  end
  
  def remove_uncheck_condition
    ::Issues::SearchConditions::ATTRIBUTE_NAMES.each do |attr|
      target_attr = attr.to_s.end_with?("_id") ? attr.to_s.gsub(/_id/, "") : attr
      unless @condition.send("#{target_attr}_check") == true
        @query_fields.delete(target_attr)
      end
    end
  end

  def set_issue_custom_fields
    @custom_fields = @issue.issue_type_id.nil? ? CustomField.issues : CustomField.issues_for_issue_type(@issue.issue_type_id)
    @custom_fields.each do |custom_field|
      @issue.issue_custom_fields << IssueCustomField.new(custom_field_id: custom_field.id) unless @issue.issue_custom_fields.map(&:custom_field_id).include?(custom_field.id)
    end
  end
  def issue_params
    params.require(:issue).permit!
  end

  def set_fields
    @issue_types = IssueType.joins(:issue_type_sites).where("issue_type_sites.site_id IN (1)")
    # @workflow_states = WorkflowState.joins(workflow: :workflow_sites).where("workflow_sites.site_id IN (1)")
  end

end
