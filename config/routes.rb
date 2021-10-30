Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  authenticated do
    root to: 'rooms#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  namespace :rooms do
    resources :directs, only: %i[create]
    resources :groups, only: %i[new create]
  end

  resources :rooms, only: %i[index show] do
    resources :additional_messages, only: %i[index]
    resources :messages, only: %i[create]
  end

  resources :users, only: %i[index]
end
