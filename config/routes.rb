Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :chats, only: %i[index show create]
  # Chats resources will be used by:
  # 1 - INDEX via the homepage (logged-in)
  #   if not logged in, the user only sees the homepage (pages#home) without their chat history
  #   if logged in, the user sees their previous chats by calling chats#index
  # 2 - CREATE via the form on the homepage when the user clicks on "submit". No need of NEW, because there is no dedicated page for the form
  # 3- SHOW via the chat screen to display a specific chat

  resources :movies, only: %i[new create show]
end
