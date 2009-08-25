ActionController::Routing::Routes.draw do |map|
  map.resources :bulletins
  map.resources :reports, :collection => {:rower_history => :get, 
                                          :crew_history => :get, 
                                          :boat_utilization => :get,
                                          :my_rowing_breakdown => :get,
                                          :boat_usage_by_crew => :get,
                                          :crew_usage_of_boats => :get}
  # The priority is based upon order of creation: first created -> highest priority.
   
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.root :controller => "summary", :action => 'index'
  map.signup '/signup', :controller => "account", :action => "signup"
  map.logout '/logout', :controller => "account", :action => "logout"
  map.login '/login', :controller => "account", :action => "login"
  map.reset '/reset', :controller => "account", :action => "reset"
  map.activate '/activate/:activation_code', :controller => "account", :action => "activate"
  map.summary '/summary', :controller => "/summary", :action => 'index'
  map.admin '/admin', :controller => "admin", :action => 'index'
  
  map.connect '/users/users_for_lookup.js', :controller => "users", :action => 'users_for_lookup'
  map.connect '/tides/summary/:number', :controller => "tides", :action => "summary", :number => nil
  map.connect '/events/new/:team', :controller => 'events', :action => 'new', :team => nil
  map.team_summary '/teams/summary/:id/:time', :controller => 'teams', :action => 'summary', :id => nil, :time => 'future'
  map.user_rss '/users/rss/:login', :controller => 'users', :action => 'rss', :login => nil
  map.sparklines "sparklines/:action/:id/image.png", :controller => "sparklines"
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
