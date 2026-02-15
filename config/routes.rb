Rails.application.routes.draw do
  root "summary#index"

  resources :bulletins
  resources :boats
  resources :reports, only: [:index] do
    collection do
      get :rower_history
      get :crew_history
      get :boat_utilization
      get :my_rowing_breakdown
      get :boat_usage_by_crew
      get :crew_usage_of_boats
    end
  end

  get '/signup', to: 'account#signup', as: :signup
  post '/signup', to: 'account#create'
  get '/login', to: 'account#login', as: :login
  post '/login', to: 'account#authenticate'
  get '/logout', to: 'account#logout', as: :logout
  get '/reset', to: 'account#reset', as: :reset
  post '/reset', to: 'account#send_reset'
  get '/activate/:activation_code', to: 'account#activate', as: :activate

  get '/summary', to: 'summary#index', as: :summary
  get '/admin', to: 'admin#index', as: :admin

  resources :users do
    collection do
      get :users_for_lookup
    end
  end
  get '/users/rss/:login', to: 'users#rss', as: :user_rss

  resources :tides do
    collection do
      get 'summary(/:number)', to: 'tides#summary', as: :summary
      get :upload
      post :import
    end
  end

  resources :events do
    collection do
      get 'new/:team', to: 'events#new', as: :new_for_team
    end
  end

  resources :teams do
    member do
      get 'summary/:time', to: 'teams#summary', as: :summary, defaults: { time: 'future' }
    end
  end

  # Legacy sparklines - might need replacement or specialized controller
  # Modernized sparklines route
  get "sparklines/:id/image", to: "sparklines#index", as: :sparkline

  # Standard Rails 8 health check
  get "up" => "rails/health#show", as: :rails_health_check
  get "/.well-known/appspecific/com.chrome.devtools.json", to: proc { [200, {"Content-Type" => "application/json"}, ["{}"]] }

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
