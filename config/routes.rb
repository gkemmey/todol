Rails.application.routes.draw do
  resources :todos, path: "" do
    # todo: update many
  end

  root "todos#index"
end
