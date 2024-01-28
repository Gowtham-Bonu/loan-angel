Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'dashboard#index', constraints: RoleConstraint.new, as: :admin_root
  root 'pages#index'

  get 'admin/active_loans', to: 'dashboard#active_loans', as: :admin_active_loans
  get 'admin/closed_loans', to: 'dashboard#closed_loans', as: :admin_closed_loans
  get 'admin/balance', to: 'dashboard#check_premium_wallet', as: :premium_wallet_balance

  get '/confirmation_requests', to: 'pages#confirmation_requests', as: :confirmation_requests
  get '/active_loans', to: 'pages#active_loans', as: :active_loans
  get '/rejected_loans', to: 'pages#rejected_loans', as: :rejected_loans
  get '/closed_loans', to: 'pages#closed_loans', as: :closed_loans
  get '/balance', to: 'pages#check_wallet', as: :wallet_balance

  devise_for :users
  resources :loans, only: [:create, :new] do
    member do
      get 'approve'
      get 'reject'
      get 'edit_interest'
      post 'update_interest'
      get 'open'
      get 'reject_loan_user'
      post 'repay_loan'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
