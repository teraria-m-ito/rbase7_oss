module Admin
  class SystemSettingsController < AdminApplicationController
    include ::Rbase::Passenger::Extendable # 継承を許可する宣言（必須）

    before_action :set_system_setting, only: [:show, :edit, :update, :destroy, :change_setting_category_div_for_edit]
    before_action :setup_values, only: [:index, :new, :edit, :show, :change_setting_category_div_for_new, :change_setting_category_div_for_edit]
    before_action :set_unique_key, only: [:new, :edit, :change_setting_category_div_for_new, :change_setting_category_div_for_edit]

    # skip_before_action :verify_authenticity_token, only: [:change_setting_category_div_for_new]

    respond_to :html
    def index
      if params[:clear] == "true"
        session[:system_settings_search_conditions] = nil
      end

      if params[:system_settings_search_conditions]
        @condition = SystemSettings::SearchConditions.new(search_condition_params)
        return render 'index' unless @condition.valid?
        @condition.current_admin_user = current_admin_user
        session[:system_settings_search_conditions] = @condition
        
        @system_settings = @condition.search.page(params[:page])
      else
        if session[:system_settings_search_conditions]
          @condition = session[:system_settings_search_conditions]
          @condition.current_admin_user = current_admin_user
          @system_settings = @condition.search.page(params[:page])
        else
          @condition = SystemSettings::SearchConditions.new
        end
      end
    end

    def show
      @setting_category_div_entries = SystemSetting.setting_category_div_entries
      @setting_div_entries = SystemSetting.setting_div_entries
      @system_setting.hint = @system_setting.setting_div_entry[:hint]
      respond_with(@system_setting)
    end

    def new
      @system_setting = SystemSetting.new({uuid: @uuid})
      @setting_category_div_entries = SystemSetting.setting_category_div_entries
      @setting_div_entries = [] #SystemSetting.setting_div_entries
      
      @stimulus_params = {
        url1: change_setting_category_div_for_new_admin_system_settings_path,
        url2: admin_system_setting_system_setting_attachments_path(::SystemSetting.new(id: 0)),
        confirm_message: I18n.t(:"views.common.create_confirm_message")
      }.to_json
          
      respond_with(@system_setting)
    end

    def edit
      setup_setting_divs
      @system_setting.uuid = @uuid
      
      @stimulus_params = {
        url1: change_setting_category_div_for_edit_admin_system_setting_path(@system_setting),
        url2: admin_system_setting_system_setting_attachments_path(@system_setting),
        confirm_message: I18n.t(:"views.common.update_confirm_message")
      }.to_json
    end

    # def create
      # @system_setting = SystemSetting.new(system_setting_params)
      # if @system_setting.valid?
        # @system_setting.save!
        # flash[:notice] = t("views.common.create_complete_message")
        # respond_with(@system_setting, location: admin_system_settings_url)
      # else
        # setup_values
        # setup_setting_divs
        # respond_with(@system_setting, location: new_admin_system_setting_path)
      # end
    # end

    def create
      params[:system_setting][:system_setting_attachments_attributes] = []
      @system_setting = SystemSetting.new(system_setting_params)

      ActiveRecord::Base.transaction do
        if @system_setting.save
          SystemSettingAttachment.where(["token = ?", @system_setting.uuid]).each do |attach|
            attach.system_setting = @system_setting
            attach.save!
          end

          #設定で再起動が必要な場合を候補して、再ロードを行う．
          if @system_setting.setting_div_entry[:reload] == true
            passenger_restart
          end

          @system_setting
          flash[:notice] = t("views.common.create_complete_message")
          respond_with(@system_setting, location: admin_system_settings_url)
        else
          setup_values
          setup_setting_divs
          respond_with(@system_setting, location: new_admin_system_setting_path)
        end
      end
    end

    # def update
      # # 子テーブルでエラーにした場合、assign_attributes時にsaveされる不具合の対応(updateで保存させる)
# #      @system_setting.assign_attributes(system_setting_params)
# #      if @system_setting.valid?
      # if @system_setting.update(system_setting_params)
        # @system_setting.save!
        # flash[:notice] = t("views.common.update_complete_message")
        # respond_with(@system_setting, location: admin_system_settings_url)
      # else
        # setup_values
        # setup_setting_divs
        # respond_with(@system_setting, location: edit_admin_system_setting_path(@system_setting))
      # end
    # end

    def update
      ActiveRecord::Base.transaction do
        @system_setting.assign_attributes(system_setting_params)
        if @system_setting.save
          SystemSettingAttachment.delete(@system_setting.system_setting_attachments.map(&:id))
          SystemSettingAttachment.where(["token = ?", @system_setting.uuid]).each do |attach|
            attach.system_setting = @system_setting
            attach.save!
          end
          #設定で再起動が必要な場合を候補して、再ロードを行う．
          if @system_setting.setting_div_entry[:reload] == true
            passenger_restart
          end

          flash[:notice] = t("views.common.update_complete_message")
          respond_with(@system_setting, location: admin_system_settings_url)
        else
          setup_values
          setup_setting_divs
          respond_with(@system_setting, location: edit_admin_system_setting_path(@system_setting))
        end
      end
    end

    def destroy
      system_setting_clone = @system_setting.dup
      flash[:notice] = t("views.common.destroy_complete_message") if @system_setting.destroy
      #設定で再起動が必要な場合を候補して、再ロードを行う．
      if system_setting_clone.setting_div_entry[:reload] == true
        passenger_restart
      end
      respond_with(@system_setting, location: admin_system_settings_url)
    end

    desc :auth_as => :index
    def change_setting_category_div_for_new
      @system_setting = SystemSetting.new(system_setting_params)
      @system_setting.uuid = @uuid
      setup_values
      setup_setting_divs
      # render :partial => 'new_form'
      render turbo_stream: turbo_stream.replace('entry-forms', partial: 'new_form')
    end

    desc :auth_as => :index
    def change_setting_category_div_for_edit
      @system_setting.assign_attributes(system_setting_params)
      @system_setting.uuid = @uuid
      setup_values
      setup_setting_divs
      render turbo_stream: turbo_stream.replace('entry-forms', partial: 'edit_form')
    end    
    private
    def setup_values
      @sites = current_admin_user.sites.all
    end
    
    def setup_setting_divs
      if @system_setting.setting_div.blank?
        @setting_category_div_entries = SystemSetting.setting_category_div_entries
      else
        @setting_category_div_entries = SystemSetting.setting_category_div_entries.select{|x|x[:key] == @system_setting.setting_div_entry[:category]}
        @system_setting.hint = @system_setting.setting_div_entry[:hint]
      end
      
      if @system_setting.setting_category_div.blank?
        @setting_div_entries = [] #SystemSetting.setting_div_entries
      else
        @setting_div_entries = SystemSetting.setting_div_entries.select{|x|x[:category] == @system_setting.setting_category_div_entry[:key]}
      end
    end
    
    def set_system_setting
      @system_setting = SystemSetting.find(params[:id])
    end

    def search_condition_params
      params[:system_settings_search_conditions][:sites].to_a.reject!{|x|x.blank?}
      params.require(:system_settings_search_conditions).permit!
    end
    
    def system_setting_params
      params.require(:system_setting).permit!
    end
    
    def set_unique_key
      @uuid = SystemSetting.set_unique_key
    end
  end
end
