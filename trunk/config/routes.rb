ActionController::Routing::Routes.draw do |map|
  map.resources :accessories

  map.resources :plans

  map.resources :phones

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.connect '', :controller => "phones", :action => 'offers', :id => '1'

  # See how all your routes lay out with "rake routes"
  map.connect 'phones/list/offers', :controller => 'phones', :action => 'offers', :id => '1'
  map.connect 'phones/list/prepaid', :controller => 'phones', :action => 'prepaid', :id => '1'
  map.connect 'phones/list/nextg', :controller => 'phones', :action => 'nextg', :id => '1'
  map.connect 'phones/list/pda', :controller => 'phones', :action => 'pda', :id => '1'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end