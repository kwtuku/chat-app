Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  authenticated do
    root to: 'rooms#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :entries, only: %i[create]

  resources :rooms, only: %i[index show] do
    resources :messages, only: %i[create]
  end

  resources :users, only: %i[index]

  get '/show_additionally', to: 'rooms#show_additionally'
end
