Rails.application.routes.draw do
  # Admin constraint
  admin_constraint = lambda do |request|
    request.env['warden'].authenticate? && request.env['warden'].user.admin?
  end
  non_admin_constraint = lambda do |request|
    request.env['warden'].authenticate? && !request.env['warden'].user.admin?
  end

  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  constraints admin_constraint do
    # Only admin users should be able to search
    resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
      concerns :searchable
    end
  end

  devise_for :users

  root to: 'contribute#redirect'

  constraints non_admin_constraint do
    get '/dashboard', to: 'contribute#redirect'
  end

  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'

  curation_concerns_basic_routes

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :batches, controller: 'hyrax/batches', only: [:index, :show, :create]

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :xml_imports,
            controller: 'hyrax/xml_imports',
            only:       [:show, :create, :new, :edit, :update]

  resources :templates,
            controller: 'hyrax/templates',
            only:       [:index, :destroy, :edit, :update, :new]
  resources :template_updates,
            controller: 'hyrax/template_updates',
            only:       [:index, :new, :create]

  # Routes for managing drafts
  post '/draft/save_draft/:id', to: 'tufts/draft#save_draft'
  post '/draft/delete_draft/:id', to: 'tufts/draft#delete_draft'
  get '/draft/draft_saved/:id', to: 'tufts/draft#draft_saved'

  # Routes for managing QR status
  resources :qr_statuses, controller: 'tufts/qr_status', only: [:set_status, :status] do
    member do
      post 'set_status'
      get 'status'
    end
  end

  resources :deposit_types do
    get 'export', on: :collection
  end

  resources :contribute, as: 'contributions', controller: :contribute, only: [:index, :new, :create, :redirect] do
    collection do
      get 'license'
    end
  end

  # Routes for managing QR status
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/handle/log/', to: 'tufts/handle_log#index'

  # needs to be last to redirect /bad/paths
  get '*path', to: 'contribute#redirect'
end
