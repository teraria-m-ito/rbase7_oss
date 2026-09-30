module Admin
  class TranslationsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable

    before_action :set_sites
    before_action :set_translation, only: [:show, :edit, :update, :destroy]

    helper_method :admin_translations_index_path_with_conditions

    respond_to :html

    def index
      if params[:clear] == "true"
        session[:translations_search_conditions] = nil
      end

      if params[:translations_search_conditions]
        @condition = ::Translations::SearchConditions.new(search_condition_params)
        return render 'index' unless @condition.valid?

        session[:translations_search_conditions] = condition_session_hash(@condition)
        @translations = paginate_search_results(@condition.search)
      elsif session[:translations_search_conditions].present?
        @condition = ::Translations::SearchConditions.new(session[:translations_search_conditions])
        @translations = paginate_search_results(@condition.search)
      else
        @condition = ::Translations::SearchConditions.new
        @translations = paginate_search_results(@condition.search)
        session[:translations_search_conditions] = condition_session_hash(@condition)
      end
      render :index
    end

    def show
      respond_with(@translation)
    end

    def new
      @translation = Translation.new(
        locale: params[:locale].presence || I18n.locale.to_s,
        key: params[:key],
        value: params[:value],
        scope: params[:scope]
      )
      respond_with(@translation)
    end

    def edit
    end

    def create
      @translation = Translation.new(translation_params)
      if @translation.save
        flash[:notice] = t("views.common.create_complete_message")
        respond_with(@translation, location: admin_translations_index_path_with_conditions)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @translation.update(translation_params)
        flash[:notice] = t("views.common.update_complete_message")
        respond_with(@translation, location: admin_translations_index_path_with_conditions)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @translation.destroy
      respond_with(@translation, location: admin_translations_index_path_with_conditions)
    end

    private

    def paginate_search_results(results)
      Kaminari.paginate_array(Array(results)).page(params[:page])
    end

    def set_translation
      @translation = Translation.find(params[:id])
    end

    def translation_params
      params.require(:translation).permit(:locale, :key, :value, :scope, :is_proc)
    end

    def search_condition_params
      params.require(:translations_search_conditions).permit(:locale, :key, :value, :scope)
    end

    def condition_session_hash(condition)
      {
        "locale" => condition.locale,
        "key" => condition.key,
        "value" => condition.value,
        "scope" => condition.scope
      }
    end

    # 一覧へ戻る際にセッション上の検索条件をクエリへ引き継ぐ
    def admin_translations_index_path_with_conditions
      condition = session[:translations_search_conditions]
      return admin_translations_path if condition.blank?

      admin_translations_path(translations_search_conditions: condition)
    end
  end
end
