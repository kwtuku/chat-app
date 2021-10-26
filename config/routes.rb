Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root 'rooms#index'

  resources :messages, only: %i[create]

  resources :rooms, only: %i[index show]

  get '/show_additionally', to: 'rooms#show_additionally'
end
