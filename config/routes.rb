Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # For creation of flats
  resources :flats, only: %i[create edit update show] do
    member do
      # add flatmates to the flat
      get "/add_flatmates", to: "flats#add_flatmates", as: :add_flatmates_to
      # set up chores
      get "/add_chores", to: "chores#new"
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
