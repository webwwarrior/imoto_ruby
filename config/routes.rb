Rails.application.routes.draw do
  require 'sidekiq/web'

  if Rails.env.development? || Rails.env.staging?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  namespace :admin do
    resources :admins
    resources :contact_requests,   only: [:index, :show, :destroy]
    resources :customers,          only: [:index, :edit, :update, :destroy, :show]
    resources :companies do
      resources :customize_prices, only: [:edit, :create, :update, :destroy]
    end
    resources :orders, only: [:index, :show, :destroy, :edit, :update] do
      resources :order_attributes,    only: :destroy
    end
    resources :products
    resources :photographers
    resources :zip_codes, only: :index
    resources :categories
    resources :coupons

    root to: 'customers#index'
  end

  match '/graphql' => 'graphql#query', via: [:options, :post]

  devise_for :customers, skip: [:sessions, :registrations, :passwords]
  devise_for :photographers, skip: [:sessions, :registrations, :passwords],
                             controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_for :admins

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :webhooks do
    namespace :google_calendar do
      resources :events, only: [:create]
    end
    namespace :ewarp do
      resources :notify, only: [:index]
    end
  end
end
