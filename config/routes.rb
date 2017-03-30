Rails.application.routes.draw do
  resources :companies, only: [:index, :create] do
    post :generate, on: :collection
  end
end
