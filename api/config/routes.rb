# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resource :api_key, controller: 'users/api_key', only: [:create, :destroy]

      member do
        put :generate_api_key # Deprecated
        put :clear_api_key # Deprecated
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    resources :promotions, only: [:show]

    resources :products, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :images, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :variants, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :product_properties, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    end

    concern :order_routes do
      resources :line_items, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :payments, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        member do
          put :authorize
          put :capture
          put :purchase
          put :void
          put :credit
        end
      end

      resources :addresses, only: [:show, :update]

      resources :return_authorizations, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        member do
          put :cancel
        end
      end

      resources :customer_returns, only: [:index, :create, :new, :edit, :show, :update]
    end

    resources :checkouts, only: [:update], concerns: :order_routes do
      member do
        put :next
        put :advance
        put :complete
      end
    end

    resources :variants, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :images, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    end

    resources :option_types, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :option_values, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    end
    resources :option_values, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    get '/orders/mine', to: 'orders#mine', as: 'my_orders'
    get "/orders/current", to: "orders#current", as: "current_order"

    resources :orders, only: [:index, :create, :new, :edit, :show, :update, :destroy], concerns: :order_routes do
      member do
        put :cancel
        put :empty
        put :apply_coupon_code
      end

      resources :coupon_codes, only: [:create, :destroy]
    end

    resources :zones, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    resources :countries, only: [:index, :show] do
      resources :states, only: [:index, :show]
    end

    resources :shipments, only: [:create, :update] do
      collection do
        post 'transfer_to_location'
        post 'transfer_to_shipment'
        get :mine
      end

      member do
        get :estimated_rates
        put :select_shipping_method

        put :ready
        put :ship
        put :add
        put :remove
      end
    end
    resources :states, only: [:index, :show]

    resources :taxonomies, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      member do
        get :jstree
      end
      resources :taxons, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        member do
          get :jstree
        end
      end
    end

    resources :taxons, only: [:index]

    resources :inventory_units, only: [:show, :update]

    resources :users, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :credit_cards, only: [:index]
      resource :address_book, only: [:show, :update, :destroy]
    end

    resources :credit_cards, only: [:update]

    resources :properties, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    resources :stock_locations, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :stock_movements, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :stock_items, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    end

    resources :stock_items, only: [:index, :update, :destroy]

    resources :stores, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    resources :store_credit_events, only: [] do
      collection do
        get :mine
      end
    end

    get '/config/money', to: 'config#money'
    get '/config', to: 'config#show'
    put '/classifications', to: 'classifications#update', as: :classifications
    get '/taxons/products', to: 'taxons#products', as: :taxon_products
  end
end
