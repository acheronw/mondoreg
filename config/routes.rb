Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  get 'users/new'


  resources :ticket_orders, only: [:create, :index, :show]
  patch 'confirm_ticket', to: 'ticket_orders#confirm_ticket'
  patch 'unconfirm_ticket', to: 'ticket_orders#unconfirm_ticket'
  patch 'refund_ticket', to: 'ticket_orders#refund_ticket'
  patch 'deliver_ticket', to: 'ticket_orders#deliver_ticket'
  put 'reminder_email', to: 'ticket_orders#reminder_email'
  get 'export_csv', to: 'ticket_orders#export_csv'
  get 'lookup_ticket', to: 'ticket_orders#lookup_ticket'

  resources :bank_transactions, only: [:destroy] do
    # collection routes work on the whole class, not on individual instances:
    collection do
      post 'import'
    end
  end
  patch 'set_done/:id', to: 'bank_transactions#set_done', as: :set_done
  patch 'set_problematic/:id', to: 'bank_transactions#set_problematic', as: :set_problematic


  resources :comp_applications
  patch 'accept_application', to: 'comp_applications#accept_application'
  patch 'reject_application', to: 'comp_applications#reject_application'
  patch 'update_memo', to: 'comp_applications#update_memo'

  resources :competitions, only: [:show]
  get 'export_competitors/:id', to: 'competitions#export_csv', as: :export_competitors

  resources :users
  patch 'edit_subscription', to: 'users#edit_subscription'
  get 'export_subscriber_csv', to: 'users#export_subscriber_csv'

  
  resources :mondo_subscriptions, only: [:create] do
    collection do
      post 'import'
    end
  end

  resources :booths
  

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/mondo', to: 'static_pages#mondo_magazine'
  get '/ticket_stats', to: 'static_pages#ticket_stats', as: :ticket_stats

  namespace :payment do
    get "checkout/:id", to: "pages#checkout", as: "checkout"
    post "notify", to: "pages#notify", as: "notify"
    post "success", to: "pages#success", as: "success"
    post "failure", to: "pages#failure", as: "failure"
    # If the user does not wait to be redirected home, but clicks the link, he arrives back without any parameters with a GET:
    get "failure", to: "/static_pages#home"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
