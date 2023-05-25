Rails.application.routes.draw do
  resources :todos, path: "" do
    patch :update_many, on: :collection
  end

  root "todos#index"
end
