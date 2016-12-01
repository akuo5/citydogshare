Citydogshare::Application.routes.draw do
  ## Route Route ##
  root :to => 'welcome#index'

  ## Session Routes ##
  get 'auth/:provider/callback', to: 'sessions#handle_auth', as: 'auth_success'
  get 'auth/failure', to: 'sessions#handle_failure', as: 'auth_failure'
  delete 'destroy', to: 'sessions#destroy', as: 'destroy'
  delete 'signout', to: 'sessions#destroy', as: 'signout'
  get 'create', to: 'sessions#create', as: 'create_session'
  get 'login', to: 'sessions#login', as: 'login'
  get 'signup', to: 'sessions#signup', as: 'signup'
  
  ## User Routes ##
  resources :users, only: [:show, :edit, :update, :destroy, :index] 
  post 'users/:id/edit', to: 'users#edit'
  get 'users/:id/info', to: "users#info", as: "user_info"
  get 'users/pro', to: "users#pro", as: "pro_user"
  # post 'users/:id/toggle', to: "users#toggle", as: "toggle_pro"
  match 'users/:id/toggle', to: "users#toggle", via: :post

  ## Dog Routes ##
  get 'dogs/:id/info', to: "dogs#info", as: "dog_info"
  get 'dogs/info', to: "dogs#all_info", as: "dogs_info"
  resources :dogs

  ## Event Routes ##
  put 'events/', :to => 'events#index'
  get "events/fc_info", to: "events#fc_info", as: "events_info"
  resources :events, :only => [:index, :new, :create, :edit, :update, :show, :destroy]

  resources :mixes, :only => [:index, :show] do
    collection do
      get :autocomplete
    end
  end

  resource :starred_dogs, only: [:create, :destroy]
  resources :users do
    member do
      get 'stars'
      get 'dogs'
    end
  end
  #dog multiple pictures
  resources :pictures

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'dashboard' => 'welcome#dashboard'
end
