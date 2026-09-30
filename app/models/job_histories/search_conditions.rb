module JobHistories
  class SearchConditions
    include ActiveModel::Model
    include ::SelectableAttr::Base

    attr_accessor :page

    attr_accessor :current_admin_user
    attr_accessor :sort_condition

    def search
      job_manages = ::JobManage

      unless current_admin_user.admin?
        job_manages = job_manages.where(request_by: current_admin_user.id)
      end

      # ソート設定
      if self.sort_condition.present?
        self.sort_condition.each do |k ,v|
          case k
          when :job_type then
            field_name = "job_manages.job_type"
          when :status then
            field_name = "job_manages.status"
          else
            field_name = k
          end

          if v[:direction] == :desc
            job_manages = job_manages.order("#{field_name} desc")
          elsif v[:direction] == :asc
            job_manages = job_manages.order("#{field_name}")
          end
        end
      else
        job_manages = job_manages.order("job_manages.updated_at desc").all
      end
      job_manages
    end
  end
end
