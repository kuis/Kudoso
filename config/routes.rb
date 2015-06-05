Rails.application.routes.draw do

  resources :contacts

  resources :tickets

  resources :notes

  resources :activity_types

  resources :content_ratings

  resources :contents

  resources :content_descriptors

  resources :content_types

  resources :activity_templates

  resources :device_types

  resources :todo_groups

  resources :todo_templates



  devise_for :users, :controllers => { :sessions => "users/sessions" }

  resources :families do
    resources :devices
    resources :family_activities
    member do
      devise_for :members, class: 'Member', :controllers => { :sessions => "members/sessions" }
      resources :todo_groups do
        member do
          post :assign
        end
      end
    end
    resources :members do
      resources :activities do
        resources :activity_details
      end
      resources :my_todos
      resources :screen_times
      resources :st_overrides
      resources :screen_time_schedules
    end



    resources :todo_groups
    resources :todos do
      resources :todo_schedules do
        resources :members do
          resources :activities do
            resources :activity_details
          end
          resources :my_todos
          resources :screen_times
        end
      end
    end
  end

  namespace :admin do
    resources :api_devices
    resources :contacts
    resources :families
    resources :todo_templates
    resources :devices
    resources :device_types
    resources :todo_groups
    resources :todo_templates
    resources :activity_templates
    resources :tickets
  end

  constraints subdomain: 'api' do
    namespace :api, path: nil, defaults: { format: 'json' } do
      namespace :v1 do
        resources :sessions
        resources :families
      end
    end

  end

  get 'tos', to: 'home#tos'
  get 'privacy', to: 'home#privacy'
  get 'contact', to: 'home#contact'
  get 'support', to: 'home#support'
  get 'newsletter', to: 'home#newsletter'
  get 'landing', to: 'home#landing'
  get 'privacy', to: 'home#privacy'
  get 'screen_time_limits', to: 'home#screen_time_limits'
  get 'content_filtering', to: 'home#content_filtering'
  get 'kudos', to: 'home#kudos'
  get 'rewards', to: 'home#rewards'
  get 'wizard', to: 'wizard#index'
  root to: 'home#landing'

  match "*path", to: "errors#catch_404", via: :all

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
