Rails.application.routes.draw do
  root "site#home"

  resources :lists, except: [:new, :edit] do
    resources :todos, except: [:new, :edit] do
      # todo: update many
    end

    # todo: share it
  end
end
