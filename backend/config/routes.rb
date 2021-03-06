# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    get '/search/users', to: "search#users", as: :search_users
    get '/search/products', to: "search#products", as: :search_products

    put '/locale/set', to: 'locale#set', defaults: { format: :json }, as: :set_locale

    resources :dashboards, only: [] do
      collection do
        get :home
      end
    end

    resources :promotions, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :promotion_rules, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :promotion_actions, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :promotion_codes, only: [:index, :new, :create]
      resources :promotion_code_batches, only: [:index, :new, :create] do
        get '/download', to: "promotion_code_batches#download", defaults: { format: "csv" }
      end
    end

    resources :promotion_categories, only: [:index, :create, :new, :edit, :update, :destroy]

    resources :zones, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    resources :tax_categories, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    resources :products, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :product_properties, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        collection do
          post :update_positions
        end
      end
      resources :variant_property_rule_values, only: [:destroy] do
        collection do
          post :update_positions
        end
      end
      resources :images, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        collection do
          post :update_positions
        end
      end
      member do
        post :clone
      end
      resources :variants, only: [:index, :edit, :update, :new, :create, :destroy] do
        collection do
          post :update_positions
        end
      end
      resources :variants_including_master, only: [:update]
      resources :prices, only: [:destroy, :index, :edit, :update, :new, :create]
    end
    get '/products/:product_slug/stock', to: "stock_items#index", as: :product_stock

    resources :option_types, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      collection do
        post :update_positions
        post :update_values_positions
      end
    end

    delete '/option_values/:id', to: "option_values#destroy", as: :option_value

    resources :properties, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    delete '/product_properties/:id', to: "product_properties#destroy", as: :product_property

    resources :orders, only: [:index, :create, :new, :edit, :update, :destroy] do
      member do
        get :cart
        put :advance
        get :confirm
        put :complete
        post :resend
        get "/adjustments/unfinalize", to: "orders#unfinalize_adjustments"
        get "/adjustments/finalize", to: "orders#finalize_adjustments"
        put :approve
        put :cancel
        put :resume
      end

      resource :customer, controller: "orders/customer_details"
      resources :customer_returns, only: [:index, :new, :edit, :create, :update] do
        member do
          put :refund
        end
      end

      resources :adjustments, only: [:index, :create, :new, :edit, :show, :update, :destroy]
      resources :return_authorizations, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        member do
          put :fire
        end
      end
      resources :payments, only: [:index, :new, :show, :create] do
        member do
          put :fire
        end

        resources :log_entries, only: [:index, :create, :new, :edit, :show, :update, :destroy]
        resources :refunds, only: [:new, :create, :edit, :update]
      end

      resources :reimbursements, only: [:index, :create, :show, :edit, :update] do
        member do
          post :perform
        end
      end

      resources :cancellations, only: [:index] do
        collection do
          post :short_ship
        end
      end
    end

    resource :general_settings, only: :edit
    resources :stores, only: [:index, :new, :create, :edit, :update]

    resources :return_items, only: [:update]

    resources :taxonomies, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      collection do
        post :update_positions
      end
      resources :taxons, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
        resource :attachment, controller: 'taxons/attachment', only: [:destroy]
      end
    end

    resources :taxons, only: [:index, :show] do
      collection do
        get :search
      end
    end

    resources :reimbursement_types, only: [:index]
    resources :adjustment_reasons, only: [:index, :create, :new, :edit, :update]
    resources :refund_reasons, only: [:index, :create, :new, :edit, :update]
    resources :return_reasons, only: [:index, :create, :new, :edit, :update]
    resources :store_credit_reasons, only: [:index, :create, :new, :edit, :update, :destroy]

    resources :shipping_methods, only: [:index, :create, :new, :edit, :show, :update, :destroy]
    resources :shipping_categories, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    resources :stock_locations, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      resources :stock_movements, only: [:index]
      collection do
        post :transfer_stock
        post :update_positions
      end
    end

    resources :stock_items, only: [:index, :create, :update, :destroy]
    resources :tax_rates, only: [:index, :create, :new, :edit, :show, :update, :destroy]

    resources :payment_methods, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      collection do
        post :update_positions
      end
    end

    resources :users, only: [:index, :create, :new, :edit, :show, :update, :destroy] do
      member do
        get :orders
        get :items
        get :addresses
        put :addresses
      end
      resources :store_credits, only: [:index, :create, :new, :edit, :show, :update] do
        member do
          get :edit_amount
          put :update_amount
          get :edit_validity
          put :invalidate
        end
      end
    end

    resources :style_guide, only: [:index]
  end

  get '/admin', to: 'admin/root#index', as: :admin
end
