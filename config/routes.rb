Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks,
              controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"

    devise_for :users, controllers: { registrations: "users/registrations" },
                       skip: :omniauth_callbacks
    devise_scope :user do
      get "signup", to: "devise/registrations#new"
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
    end

    get "pages/search", to: "pages#search", as: "search_page"
    resources :account_activations, only: :edit
    resources :carts
    resources :password_resets, only: %i(new create edit update)
    resources :static_pages, only: %i(index show)
    resources :carts
    resources :comments, only: %i(create)
    resources :notifications

    namespace :admin do
      get "/soccer_field_path/:id", to: "soccer_fields#destroy"
      get "search_revenue", to: "revenues#search_revenue"
      resources :soccer_fields, except: %i(show)
      resources :orders, only: %i(index update)
      resources :revenues, only: :index
      resources :users, only: %i(index update)
      resources :statistics, only: %i(index)
      get :statistic_month, to: "statistics#month"
      get :statistic_week, to: "statistics#week"
      get :statistic_year, to: "statistics#year"
    end

    namespace :user do
      resources :orders
      resources :order_details, only: :destroy
      get "order_soccer_field", to: "orders#order_soccer_field"
    end
  end
end
