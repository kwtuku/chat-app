Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root 'rooms#index'

  resources :entries, only: %i[create]

  resources :messages, only: %i[create]

  resources :rooms, only: %i[index show]

  resources :users, only: %i[index]

  get '/show_additionally', to: 'rooms#show_additionally'
end
