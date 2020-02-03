Rails.application.routes.draw do

  root to: 'pras_devise/registrations#new'
  resources :users
  scope module: :pras_devise do
    resources :registrations, only: [:new, :create]
    resources :confirmations, only: [:new, :show]
    resources :sessions, only: [:new, :create, :destroy]
    resources :password_resets, only: [:new, :edit, :create, :update]
  end
end 