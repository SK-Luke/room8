Rails.application.routes.draw do
  # Uncomment below for sidekiq
  # require "sidekiq/web"
  # authenticate :user, ->(user) { user.admin? } do
  # mount Sidekiq::Web => '/sidekiq'
  devise_for :users
  root to: 'flats#home'

  # For creation of flats
  resources :flats, only: %i[create edit update show] do
    # show methods bring us to the overall room8 page where we see the users avatars cards
    member do
      # add flatmates to the flat
      get "/add_flatmates", to: "flats#add_flatmates", as: :add_flatmates_to
      # Post flatmates to /id/user
      post "/add_flat_user", to: "users#add_flat_user"
      # set up chores page after finishing adding flatmates
      get "/setup_chores", to: "chores#setup"
      # see roommate's chores --> WX: hellu, don't think this is the right action for the route
      get "/:name/chores", to: "chores#index"
      # post method for chores
      resources :chores
    end
  end

  resources :flat_users, only: %i[update create] do
    resources :chore_list, only: :index
  end
  resources :preferences, only: %i[index update]
  # documentation to be read on devise user controller, and route updated accordingly
  resources :chore_list, only: %i[update index]

  get '/task/:id', to: 'chore_list#task'
end
