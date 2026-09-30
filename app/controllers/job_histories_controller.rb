class JobHistoriesController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  respond_to :html

  before_action :set_job_manage_for_errors_show, only: :show
  before_action :authorize_job_manage_errors_show_access!, only: :show

  def index
    @model_name = "job_histories/sort_conditions"
    @sort_url = job_histories_path

    if params[:clear] == "true"
      session[:job_histories_search_conditions] = nil
      session[@model_name] = nil
    end

    @stimulus_params = {
    }.to_json

    if params[:sort_field_name]
      @sort_field_name = params[:sort_field_name].nil? ? nil : params[:sort_field_name].to_sym
      sort_condition = set_sort_field
    end

    #ソートを行うので、検索条件は非表示で対応
    if params[:job_histories_search_conditions]
      @condition = ::JobHistories::SearchConditions.new(search_condition_params)
      @condition.current_admin_user = current_admin_user
      return render 'index' unless @condition.valid?

      unless sort_condition
        session[@model_name] = nil
      end
      @condition.sort_condition = sort_condition
      @condition.page = params[:page] if params[:page].present?

      session[:job_histories_search_conditions] = @condition
      @job_histories = @condition.search.page(@condition.page)
    else
      if session[:job_histories_search_conditions]
        @condition = session[:job_histories_search_conditions]
        @condition.current_admin_user = current_admin_user
        @condition.page = params[:page] if params[:page].present?
        @condition.sort_condition = sort_condition if sort_condition
        @job_histories = @condition.search.page(@condition.page)
      else
        @condition = ::JobHistories::SearchConditions.new
        @condition.current_admin_user = current_admin_user
        @condition.sort_condition = sort_condition if sort_condition
        @condition.page = params[:page] if params[:page].present?
        session[:job_histories_search_conditions] = @condition
        @job_histories = @condition.search.page(@condition.page)
      end
    end

    #ソート場合、turbo_frame_tagの更新を行う
    if @sort_field_name
      render turbo_stream: [
        turbo_stream.replace("entry-turbo-job_history_search_results", partial: 'job_histories/search_results'),
      ]
    elsif params[:reload] == "true"
      render turbo_stream: [
        turbo_stream.replace("entry-turbo-message", partial: 'common/message'),
        turbo_stream.replace("entry-turbo-job_history_search_results", partial: 'job_histories/search_results'),
      ]
    else
      render :index
    end
  end

  def show
    @job_manage_errors = @job_manage.job_manage_errors.order(:id).page(params[:page])
  end

  private

  def set_job_manage_for_errors_show
    @job_manage = ::JobManage.find(params[:id])
  end

  def authorize_job_manage_errors_show_access!
    return if current_admin_user.blank?
    return if current_admin_user.admin?
    return if @job_manage.request_by == current_admin_user.id

    redirect_to job_histories_path(clear: true),
                alert: I18n.t("views.job_histories.show.forbidden")
  end
end
