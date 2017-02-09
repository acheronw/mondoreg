Rails.application.routes.draw do

  devise_for :users
  get 'users/new'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/ticket_policy', to: 'static_pages#ticket_policy'
  # get '/signup', to: 'users#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
