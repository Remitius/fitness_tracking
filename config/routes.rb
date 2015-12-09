Rails.application.routes.draw do
  get 'static_pages/home'

  root 'workouts#index'
  resources :workouts, path: 'w' do
    resources :exercises, only: [:create,:update,:destroy,:edit], 
    path: 'e' do
      resources :e_sets, only: [:destroy]
    end
  end

  get 'exercises/index', path: 'e'

  resources :users, path: 'u', only: [:new,:edit,:show,:create,:update]
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example resource route with options:
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

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
