ActionController::Routing::Routes.draw do |map|
  map.resources :twitter, :collection => {:auth => :get, :signin => :get, :tweet => :post}
  map.resources :users, :collection => {:login => [:get,:post], :logoff => :get}
  map.root :controller => :twitter
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
