VTool::Application.routes.draw do

  match 'login' => 'users#user_login'
  resources :users


  match 'timers/:id' => 'timers#set', :via => :post
  resources :timers

  match 'projectors/:id' => 'projectors#command', :via => :post
  match 'projectors/command' => 'projectors#command', :via => :post
  resources :projectors

  match 'group/switch/:a/:b' => 'items#switch'
  resources :items, :path => "group"
  match 'group/:id/:slide' => 'items#show'
  
  resources :slides 

  root :to => 'home#index'
  match 'debugger' => 'home#debug'
  
  match 'admin' => 'admin#index'
  match 'admin/import/antrag' => 'admin#import_antrag', :via => :post

  match "/404", :to => "home#error_404"
  match "/422", :to => "home#error_422"
  match "/500", :to => "home#error_500"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
