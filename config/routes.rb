Rails.application.routes.draw do
  devise_for :users
  root to: '/'

  get "/flats/:id/add_flatmates", to: "flats#edit"
  patch "/flats/:id/add_flatmates", to: "flats#update"

  get "/flats/:id/add_chores", to: "chores#new"
  post "/flats/:id/add_chores", to: "chores#create"

  get "/flats/:name", to: "flats#show"

  get "/flats/:name/:user_id", to: "flats#show"

  get "/preferences", to: "preferences#edit"
  patch "/preferences", to: "preferences#update"

  get "/users/:id/chore_list", to: "users#show"
  patch "/users/:id/chore_list", to: "users#update"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
