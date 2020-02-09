Rails.application.routes.draw do

  root to: 'registrations#new'
  resources :users
  resources :registrations, only: [:new, :create]
  resources :confirmations, only: [:new, :show]
  resources :sessions, only: [:new, :create]
  get 'sign_out' => "sessions#destroy"
end 