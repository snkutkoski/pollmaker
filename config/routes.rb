Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :polls, only: [:create, :show]

  resources :options, only: [] do
    member do
      post :vote
    end
  end
end
