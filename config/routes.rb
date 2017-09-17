Rails.application.routes.draw do
  root to: 'pollmaker#index'
  get 'poll/:id', to: 'pollmaker#index'

  resources :polls, only: [:create, :show]

  resources :options, only: [] do
    member do
      post :vote
    end
  end
end
