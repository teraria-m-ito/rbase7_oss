Rails.application.routes.draw do

  get 'admin/index'

  resources :top do
  end

  resources :issues do
    collection do
      post 'change_issue_type_for_index'
      post 'change_issue_type_for_new_or_edit'
    end
  end

  resources :queries do
    collection do
      patch 'select_field'
    end
    member do
      get 'load'
    end
  end

  resources :job_histories

  namespace :admin do
    resources :issue_types
    resources :sites
    resources :roles do
      member do
        post 'copy'
      end
    end
    resources :users do
      resources :admin_user_attachments do
        collection do
          patch 'create'
        end
      end
    end
    resources :workflows do
      collection do
        post 'change_sites'
      end
      resources :workflow_states do
        member do
          get 'move_up'
          get 'move_down'
        end
      end
    end
    
    resources :state_flows
    
    resources :custom_fields do
      collection do
        patch 'sort'
      end
    end
    resources :mail_templates
    resources :reports do
      member do
        get 'preview'
      end
      resources :report_attachments do
        collection do
          patch 'create'
        end        
      end#, only: [:create, :destroy]
    end

    resources :system_settings do
      collection do
        post 'change_setting_category_div_for_new'
      end
      member do
        patch 'change_setting_category_div_for_edit'
      end
      resources :system_setting_attachments do
        collection do
          patch 'create'
        end
      end
    end
  end
  
  get 'top/index'

  get 'top/show'

  root to: "top#index"
  
  devise_for :admin_users, :controllers => {
    :sessions      => "admin_users/sessions",
    :registrations => "admin_users/registrations",
    :passwords     => "admin_users/passwords"
  }

  resources 'sso' do
    collection do
      get 'metadata'
      post 'consume'
    end
  end

  match '/admin_users/:admin_user_id/admin_user_attachments(.:format)', to: 'admin_user_attachments#create', via: :patch
  match '/admin_users/:admin_user_id/admin_user_attachments/:id(.:format)', to: 'admin_user_attachments#destroy', via: :delete

  resources :admin_user_attachments

  def draw(route_file)
    instance_eval(File.read(Rails.root.join("config/routes/#{route_file}.rb")))
  end

  Dir.glob(Rails.root.join('config', 'routes', '*.rb')).sort.each do |fn|
    name = File.basename(fn, '.rb').to_sym
    draw name
  end

  get '*anything' => 'errors#routing_error'

end
