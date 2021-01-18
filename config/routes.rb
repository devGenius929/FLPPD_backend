Rails.application.routes.draw do


  #initial website
  get 'welcome/index'
  get 'confirm/:code' => 'welcome#confirm_email', constraints: { code: /[a-zA-Z\d\$\.]+/ }
  root 'welcome#index'
  get 'swagger-json' => 'apidocs#index'

  namespace :api do
    namespace :v1 do

      get 'ping' => 'services#ping'
      post 'facebook_auth' => 'users#facebook_auth'
      get 'cfg' => 'services#cfg'

      #authentication
      post 'signup' => 'users#create'
      post 'authenticate', to: 'authentication#authenticate'
      post 'apns' => 'authentication#sync'
      post 'recover', to: 'password_resets#create', as: 'recover'
      post 'verify', to: 'users#verify', as: 'verify'
      post 'generate', to: 'users#generate_pin', as: 'generate'
      delete 'logout' => 'authentication#logout'

      #users
      resources :users
      get 'users/:id/profile' => 'users#profile'
      get '/search/users' => 'users#search'
      put 'users/:id/profile' => 'users#update'
      resources :password_resets, only: [:create, :update]

      #properties
      resources :properties
      resources :property_images, except: [:index, :update]

      ##payments
      post 'plans' => 'payments#create_plan'
      post 'subscriptions' => 'payments#new_subscription'
      ##delete 'subscriptions/:id' => 'payments#cancel_subscription'
      delete 'subscriptions' => 'payments#cancel_subscription'
      put 'subscriptions/reactivate' => 'payments#reactivate_subscription'
      post '/users/:id/creditcards' => 'payments#add_creditcard'

      #networks
      get  'network' => 'networks#index'
      get  'network/:id' => 'networks#index'
      post 'network' => 'networks#create'
      put  'network/:id/accept' => 'networks#acceptConnection'
      delete  'network/:id/delete' => 'networks#deleteConnection'
      get  'pendingconnections' => 'networks#pendingConnectionsRequest'
      get  'waitingconnections' => 'networks#waitingConnectionsRequest'
      delete  'network/:id' => 'networks#destroy'

      #conversations
      get   'conversations' => 'conversations#index'
      get   'conversations/:id' => 'conversations#show'
      post  'conversations' => 'conversations#create'
      post  'conversations/:id/respond' => 'conversations#respond'
      post 'messages/:user_id' => 'messages#create'

      #favorites
      get 'favorites' => 'users#favorites'
      post 'favorites/:property_id' => 'users#add_favorite'
      delete 'favorites/:property_id' => 'users#remove_favorite'
    end
  end

  mount ActionCable.server => "/cable"
  mount SwaggerEngine::Engine, at: '/api-docs'
end
