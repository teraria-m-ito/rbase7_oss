module Issues
  class SearchConditions
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    include ActiveModel::Model
    include ::SelectableAttr::Base
    
    attr_accessor :select_field_ope_type_workflow_state_id
    attr_accessor :select_field_ope_type_issue_type_id
    attr_accessor :select_field_ope_type_priority
    attr_accessor :select_field_ope_type_title
    attr_accessor :select_field_ope_type_expression
    attr_accessor :select_field_ope_type_creator_id
    attr_accessor :select_field_ope_type_assigned_id
    attr_accessor :select_field_ope_type_changed

    
    attr_accessor :select_field_type
    attr_accessor :site_id
    ATTRIBUTE_NAMES = [:issue_type_id, :workflow_state_id, :priority, :title, :expression, :creator_id, :assigned_id, :changed]
    attr_accessor *ATTRIBUTE_NAMES
    # attr_accessor :issue_type_id
    # attr_accessor  :workflow_state_id
    # attr_accessor  :priority
    # attr_accessor  :title
    # attr_accessor  :expression
    # attr_accessor  :creator_id
    # attr_accessor  :assigned_id
    
    attr_accessor  :workflow_state_check
    attr_accessor  :workflow_state_multiple

    attr_accessor  :issue_type_check
    attr_accessor  :issue_type_multiple

    attr_accessor  :priority_check
    attr_accessor  :priority_multiple

    attr_accessor  :title_check
    attr_accessor  :expression_check

    attr_accessor  :assigned_check
    attr_accessor  :assigned_multiple

    attr_accessor  :creator_check
    attr_accessor  :creator_multiple

    attr_accessor  :changed_check

#    validates :issue_type_id, presence: true
    
    selectable_attr :condition_ope_type_select do
      entry 'equal', :equal, 'Equal', ope: "="
      entry 'not equal', :not_equal, 'Not equal', ope: "<>"
    end
      
    selectable_attr :condition_ope_type_text do
      entry 'equal', :equal, 'Equal', ope: "="
      entry 'not equal', :not_equal, 'Not equal', ope: "<>"
      entry 'include', :include, 'Include', ope: "like"
      entry 'exclude', :exclude, 'Exclude', ope: "not like"
    end
      
    selectable_attr :condition_ope_type_changed do
      entry 'changed', :changed, 'Changed', ope: nil
    end
      
    selectable_attr :condition_field_type do
      entry 'workflow_state', :workflow_state_id, 'Workflow State', field_type: :select, multi: true, default: true do
        def values(workflow_states)
          workflow_states.map{|x|[x.state_name, x.id]}
        end
      end
      entry 'issue_type', :issue_type_id, 'Issue type', field_type: :select, multi: true do
        def values(issue_types)
          issue_types.to_a.map{|x|[x.issue_type_name, x.id]}
        end
      end
      entry 'priority', :priority, 'Priority', field_type: :select, multi: true do
        def values(priority)
          Issue.priority_options
        end
      end
      entry 'title', :title, 'Title', field_type: :text
      entry 'expression', :expression, 'Expression', field_type: :text
      entry 'assigned', :assigned_id, 'Assigned', field_type: :select, multi: true do
        def values(admin_user)
          AdminUser.define_site(1).map{|x|[x.email, x.id]}
        end
      end
      entry 'creator', :creator_id, 'Creator', field_type: :select, multi: true do
        def values(admin_user)
          site_id = Thread.current[:request].session[:active_site_id]
          AdminUser.define_site(site_id).map{|x|[x.name, x.id]}
        end
      end
      entry 'updater', :updater_id, 'Updater', field_type: :select, multi: true do
        def values(admin_user)
          site_id = Thread.current[:request].session[:active_site_id]
          AdminUser.define_site(site_id).map{|x|[x.name, x.id]}
        end
      end
    end
  
    def self.default_conditions
      result = []
      enums = self.condition_field_type_enum
      enums.each do |enum|
        result << [enum[:name], enum[:id]] if enum[:default]
      end
      result
    end  
    def search
      self.site_id = Thread.current[:request].session[:active_site_id]
      
      issues = Issue.all
      issues = issues.where(site_id: self.site_id) unless self.site_id.blank?
      issues = issues.where(build_condition_string(:select, "workflow_state_id", self.workflow_state_id, self.workflow_state_multiple)) unless self.workflow_state_id.blank?
      issues = issues.where(build_condition_string(:select, "issue_type_id", self.issue_type_id, self.issue_type_multiple)) unless self.issue_type_id.blank?
      issues = issues.where(build_condition_string(:select, "priority", self.priority, self.priority_multiple)) unless self.priority.blank?
      issues = issues.where(build_condition_string(:text, "title", self.title)) unless self.title.blank?
      issues = issues.where(build_condition_string(:text, "expression", self.expression)) unless self.expression.blank?
      issues = issues.where(build_condition_string(:select, "creator_id", self.creator_id, self.creator_multiple)) unless self.creator_id.blank?
      issues = issues.where(build_condition_string(:select, "assigned_id", self.assigned_id, self.assigned_multiple)) unless self.assigned_id.blank?

      if self.changed.present?
        case self.changed
        when ::Issues::SearchConditions.condition_ope_type_changed_id_by_key(:changed)
          issues = issues.joins(voucher: {voucher_pages: :voucher_page_fields}).where("voucher_page_fields.master_value <> voucher_page_fields.value")
        end
      end

      issues = issues.distinct
      issues = issues.order("issues.created_at desc, issues.id desc")
      issues
    end
  
    private
    def build_condition_string(field_type, col, value, multi='single')
      condition_ope_type = eval("self.select_field_ope_type_#{col}")
      ope = eval("::Issues::SearchConditions.condition_ope_type_#{field_type}_enum[self.select_field_ope_type_#{col}][:ope]")
      
      sql_string = ""
      if multi == 'multi'
        if ope == '='
          sql_string = "#{col} IN (?)"
        elsif ope == '<>'
          sql_string = "#{col} NOT IN (?)"
        elsif ope == 'like'
          sql_string = "#{col} LIKE ?"
          value = "%#{value}%"
        elsif ope == 'not like'
          sql_string = "#{col} NOT LIKE ?"
          value = "%#{value}%"
        end
      else
        if ope == '='
          sql_string = "#{col} = ?"
        elsif ope == '<>'
          sql_string = "#{col} <> ? or #{col} IS NULL"
        elsif ope == 'like'
          sql_string = "#{col} LIKE ?"
          value = "%#{value}%"
        elsif ope == 'not like'
          sql_string = "#{col} NOT LIKE ?"
          value = "%#{value}%"
        end
      end
      return sql_string, value
    end
  end
    
end