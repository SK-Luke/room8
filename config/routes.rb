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
      # set up chores page after finishing adding flatmates
      get "/setup_chores", to: "chores#setup"
      # see roommate's chores
      get "/:username/chores", to: "chores#index"

      # post method for chores
      resources :chores, only: :create
    end
  end

  resources :preferences, only: %i[index update]

  # documentation to be read on devise user controller, and route updated accordingly
  resources :chore_list, only: %i[show update]
end
