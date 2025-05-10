Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "projects#index"

  resources :projects, only: %i[new create show], export: true
end