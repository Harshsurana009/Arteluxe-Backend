Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :admin do
    namespace :api do
      resources :products
      resources :images
    end
  end

  namespace :website do
    namespace :api do
      resources :products, only: %i[index show]
      post 'sign_in', to: 'auth#sign_in'
      post 'sign_up', to: 'auth#sign_up'
      get 'cart', to: 'carts#show'
      post 'add_to_cart', to: 'carts#add_to_cart'
      post 'remove_from_cart', to: 'carts#remove_from_cart'
    end
  end
end
