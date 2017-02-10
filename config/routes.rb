Rails.application.routes.draw do

  devise_for :users
  get 'users/new'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/hub', to: 'static_pages#hub', as: :hub

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
