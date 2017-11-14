Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  get 'users/new'


  put 'reminder_email', to: 'users#reminder_email'
  resources :ticket_orders, only: [:create, :index]

  resources :comp_applications
  patch 'accept_application', to: 'comp_applications#accept_application'
  patch 'reject_application', to: 'comp_applications#reject_application'

  resources :competitions, only: [:show]

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/hub', to: 'static_pages#hub', as: :hub


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
