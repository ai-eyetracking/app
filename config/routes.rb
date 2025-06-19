Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "projects#index"

  resources :projects, only: %i[new create show], export: true do
    resources :analyses, only: %i[new create], shallow: true
  end
  
  resources :analyses, only: %i[show] do
    resources :versions, controller: 'analysis_versions', only: %i[index show create]
    resources :key_areas, only: %i[index create destroy] do
      collection do
        put :bulk_update
        get :labels
      end
    end
  end
end