Citydogshare::Application.routes.draw do
  ## Route Route ##
  root :to => 'welcome#index'

  ## Session Routes ##
  get 'auth/:provider/callback', to: 'sessions#handle_auth', as: 'auth_success'
  get 'auth/failure', to: 'sessions#handle_failure', as: 'auth_failure'
  delete 'destroy', to: 'sessions#destroy', as: 'destroy'
  post'signout', to: 'sessions#signout', as: 'signout'
  get 'create', to: 'sessions#create', as: 'create_session'
  get 'login', to: 'sessions#login', as: 'login'
  get 'signup', to: 'sessions#signup', as: 'signup'
  
  ## User Routes ##
  resources :users, only: [:show, :edit, :update, :destroy, :index]
  post 'users/:id/edit', to: 'users#edit'

  ## Dog Routes ##
  resources :dogs

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
