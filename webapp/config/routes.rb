ActionController::Routing::Routes.draw do |map|
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
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.root :controller => 'site', :action => 'index'
  map.about "about", :controller => :site, :action=>:about
  map.tos "tos", :controller => :site, :action => :tos
  map.privacy "privacy", :controller => :site, :action => :privacy
  map.login "login", :controller => "user_sessions", :action => 'new'
  map.logout "logout", :controller => "user_sessions", :action => 'destroy'
  map.register "register", :controller => "users", :action => "new"
  map.settings "settings", :controller => "settings", :action => "edit"
  map.change_password "/user/change_password", :controller=>:users, :action=>:edit
  map.forgot_password "/user/forgot_password", :controller=>:users, :action=>:forgot_password
  map.reset_password "/user/reset_password", :controller=>:users, :action=>:reset_password
  map.resend_pager_activation "settings/resend_pager_activation", :controller=>:settings, :action=>:resend_pager_activation
  map.dashboard "dashboard", :controller => "users", :action => "index"
  map.archive "/todos/archive", :controller => :todos, :action=>:archive
  map.todo_categories "/todos/categories/:action/:id", :controller=>'categories'
  map.resources :users
  map.resources :user_sessions
  map.resources :settings
  map.resources :beta_invites
  map.resources :default_reminder_schedules
  map.resources :reminder_schedules
  map.resources :categories
  map.resources :todos, :collection => { :sort => :post }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
