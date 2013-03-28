Phonetic3::Application.routes.draw do
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  resources :samples
  resources :user_sessions
  resources :users
  resources :conversions
  resources :books
  resources :translate
  resources :user_settings, :only => [:new, :edit, :create, :update]
  match '/register' => 'user_settings#new', :as => :register
  match 'my-info' => 'user_settings#edit', :as => :my_info
  root :to => 'translate#index'
  match '/:controller(/:action(/:id))'
end

