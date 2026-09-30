class QueriesController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :set_query, only: [:show, :edit, :update, :destroy, :load]  
  before_action :set_queries, only: [:index, :new]  
  before_action :set_referrer, only: [:new, :edit, :destroy]
  before_action :set_target_class, only: [:index, :new, :edit, :select_field, :destroy]
  before_action :set_data_type, only: [:create, :update]
  before_action :set_field_list, only: [:index, :new, :create, :edit, :update, :select_field]

  respond_to :html
  def index
  end

  def show
  end

  def new
    @query = Query.new({target_class: @target_class})
    @condition =  Psych.safe_load(session[:"#{@data_type}_condition"], permitted_classes: [::Issues::SearchConditions])
    @query_fields = Psych.safe_load(session[:query_fields])
    @selected_query_fields = Psych.safe_load(session[:selected_query_fields])
    
    respond_with(@query)
  end

  def edit
    @condition =  Psych.safe_load(@query.query_content, permitted_classes: [::Issues::SearchConditions])
    @query_fields = Psych.safe_load(@query.query_fields)
    @selected_query_fields = Psych.safe_load(@query.selected_query_fields)

    respond_with(@query)
  end

  def create
    @query = Query.new(query_params)
    @query.admin_user_id = current_admin_user.id
    
    condition_hash = params[query_params[:target_class].gsub(/\//,"_")]
    condition_hash.permit!
    
    @condition = eval("::#{@data_type.camelize}::SearchConditions.new(condition_hash)")
    @query.query_content = @condition.blank? ? "" : @condition.to_yaml
    # @query.query_fields = session[:query_fields].blank? ? "" : session[:query_fields]
    # @query.selected_query_fields = session[:selected_query_fields].blank? ? "" : session[:selected_query_fields]
# 
    # @query_fields = Psych.safe_load(session[:query_fields])
    # @selected_query_fields = Psych.safe_load(session[:selected_query_fields])

    if @query.save
      flash[:notice] = t("views.common.create_complete_message")
      session[:refferr_url] = nil

      # return_controller = @query.target_class.split("/")[0]
      # session[:"#{return_controller}_condition"] =  Psych.safe_load(@query.query_content, permitted_classes: [::Issues::SearchConditions]).to_yaml
      # session[:query_fields] =  Psych.load(@query.query_fields).to_yaml
      # session[:selected_query_fields] =  Psych.safe_load(@query.selected_query_fields).to_yaml

      redirect_to eval("#{@data_type}_path"), turbo: false
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Query.transaction do
      @query.assign_attributes(query_params)
      @query.admin_user_id = current_admin_user.id

      condition_hash = params[query_params[:target_class].gsub(/\//,"_")]
      condition_hash.permit!

      @condition = eval("::#{@data_type.camelize}::SearchConditions.new(condition_hash)")
      @query.query_content = @condition.blank? ? "" : @condition.to_yaml
# 
      # @query_fields = Psych.safe_load(session[:query_fields])
      # @selected_query_fields = Psych.safe_load(session[:selected_query_fields])

      if @query.save
        flash[:notice] = t("views.common.update_complete_message")
        session[:refferr_url] = nil
        
        # return_controller = @query.target_class.split("/")[0]
        # session[:"#{return_controller}_condition"] =  Psych.load(@query.query_content, permitted_classes: [::Issues::SearchConditions]).to_yaml
        # session[:query_fields] =  Psych.safe_load(@query.query_fields).to_yaml
        # session[:selected_query_fields] =  Psych.safe_load(@query.selected_query_fields).to_yaml
       
        redirect_to eval("#{@data_type}_path"), turbo: false
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    flash[:notice] = t("views.common.destroy_complete_message") if @query.destroy
    set_queries
  end

  desc :auth_as => :index
  def select_field
    if session[:query_fields] 
      @query_fields = Psych.safe_load(session[:query_fields])
      @selected_query_fields = Psych.load(session[:selected_query_fields]).to_a + @query_fields.select{|x| x[1] == params[:select_field_type]}
      @query_fields.select!{|x| x[1] != params[:select_field_type]}
    else
      @query_fields = eval("::#{@data_type.camelize}::SearchConditions.condition_field_type_options")
      @selected_query_fields = [@query_fields.shift]
    end
    session[:query_fields] = @query_fields.to_yaml
    session[:selected_query_fields] = @selected_query_fields.to_yaml

    @condition = eval("::#{@data_type.camelize}::SearchConditions.new")
    
    # render turbo_stream: turbo_stream.replace("entry-forms", partial: "#{@data_type}/search_conditions")
  end
  
  desc :auth_as => :index
  def update_select_field
    render turbo_stream: turbo_stream.replace("entry-selects", partial: "#{@data_type}/search_conditions")
  end
  
  desc :auth_as => :index
  def load
    return_controller = @query.target_class.split("/")[0]
    session[:"#{return_controller}_condition"] =  Psych.safe_load(@query.query_content, permitted_classes: [::Issues::SearchConditions]).to_yaml
    session[:query_fields] =  Psych.safe_load(@query.query_fields).to_yaml
    session[:selected_query_fields] =  Psych.safe_load(@query.selected_query_fields).to_yaml
        
    redirect_to eval("#{return_controller}_path(edited: true)"), status: :see_other
  end
  
  private

  def set_query
    @query = Query.find(params[:id])
  end

  def set_queries
    @queries = (Query.owns(current_admin_user.id, params[:target_class]) + Query.shares(params[:target_class])).uniq
  end

  def set_referrer
    session[:refferr_url] = Rails.application.routes.recognize_path(request.referrer)
  end

  def query_params
    params.require(:query).permit!
  end
  
  def set_target_class
    @target_class = params[:target_class]
    /^(.*)\/(.*)$/ =~ "#{@target_class}"
    @data_type = $1
  end

  def set_data_type
    @data_type = params[:data_type]
  end
  
  def set_field_list
    @condition = eval("::#{@data_type.camelize}::SearchConditions.new")
    
    case @data_type
    when 'issues'
      @field_list = {
        workflow_state_id: WorkflowState.prohabbits_site(session[:active_site_id]),
        issue_type_id: IssueType.all,
        creator_id: AdminUser.define_site(current_admin_user.selected_site).all,
        assigned_id: AdminUser.define_site(current_admin_user.selected_site).all
      }
    end
  end
end
