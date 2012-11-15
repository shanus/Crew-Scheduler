Crew::Application.routes.draw do
  get "dashboard/index"

  authenticated :user do
    root :to => 'dashboard#index'
  end
  root :to => "dashboard#index"
  devise_for :users
  resources :users
end