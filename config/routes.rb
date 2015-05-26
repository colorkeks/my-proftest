Rails.application.routes.draw do

  resources :eqvgroups
  resources :sections
  get 'main/index'

  resources :test_groups do
    post :bulk_destroy, on: :member
    get 'bulk_move', to: :bulk_move_edit, on: :member, as: :bulk_move
    post 'bulk_move', to: :bulk_move_update, on: :member
    get 'stub_tests', on: :collection
    get 'stub_tasks', on: :collection
    get 'stub_task', on: :collection
  end

  resources :user_associations

  get 'table/index'
  root to: 'table#index', as: 'table'

  resources :tests do
    member do
      get 'create_task'
      get 'settings'
    end
    collection do
      # required for Sortable GUI server side actions
      post :rebuild
      post :expand_node
    end
  end

  resources :tasks do
    member do
      get 'create_answer'
    end
    post :bulk_destroy, on: :collection
    get 'bulk_move', to: :bulk_move_edit, on: :collection, as: :bulk_move
    post 'bulk_move', to: :bulk_move_update, on: :collection
    post :bulk_change_eqvgroup, on: :collection
  end

  devise_for :users,  :controllers => { :registrations => "users/registrations" }

  resources :users do
    member do
      get 'create_try'
      get 'create_test'
      get 'profile'
      get 'add_attestation_tests'
    end
    collection do
      post 'custom_create'
    end
  end

  resources :tries do
    member do
      get 'show_question'
      get 'try_result'
      post 'check_user_answer'
    end
  end

  resources :task_contents

  resources :admins

  resources :answers

  resources :associations

  resources :task_results

  resources :user_answers

  resources :statistics






  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
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
end
