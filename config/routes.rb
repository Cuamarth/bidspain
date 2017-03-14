Bidspain::Application.routes.draw do  

  root :to => 'bids#index'
  
  resources :bids
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  controller :products do
    get '/admin/productos/available_products' => :available_products
    get '/admin/productos/:id' => :show        
  end
  
  controller :bids do
    get 'bids/index' => :index  
    get 'bids/bidTime/:id' => :bidTime
    get 'bids/:id' => :show
  end
  
  controller :sessions do
    post 'login'  => :create
    get  'logout'  => :destroy  
  end
  
  controller :bets do
    post 'bets/create'  => :create    
  end
  
  controller :users do
    get '/user'  => :index
    get '/user/password'  => :password
    post '/user/password'  => :changepassword
    post '/user'  => :updateUser
    put '/user'  => :updateUser
    put '/user/password'  => :changepassword    
    get '/user/bids'  => :bids
    get '/user/wallet'  => :wallet   
    post '/user/paybid/:id' => :pay_bid 
    post '/user/confirmpay' => :confirmPay
    get '/user/codes' => :codes
    post '/user/codes' => :usecode
    get '/user/wallet/charged' => :charged    
    post '/user/confirmbid/:id/:type' => :confirmbid  
    get '/user/register' => :register
    post '/user/register' => :registerpost
    get '/user/welcome' => :welcomeuser
    post '/user/remind_password' => :remind_password_post
    get '/user/remind_password' => :remind_password
  end 

  controller :pays do 
    post '/pay/verify/verifypaypal' => :verifyPaypal
    post '/pay/verify/ceca' => :verifyCard
  end
 
  controller :static do 
    get '/instrucciones' => :info
    get '/quienes-somos' => :whoweare
  end
  #get 'admin/productos/products_select' => 'productos#products_select'


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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
