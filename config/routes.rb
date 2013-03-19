require 'sidekiq/web'

Crew::Application.routes.draw do
  get "dashboard/index"

  authenticated :user do
    root :to => 'dashboard#index'
  end
  root :to => "dashboard#index"
  devise_for :users
  resources :users
  
  resources :tips, :path => "help", :as => "help"
  resources :tips, :only => [:index,:show]


  resources :hulls
  resources :boats
  resources :weights
  resources :usages
  resources :events
  resources :teams
  resources :bulletins
  
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.has_role?(:admin) }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end