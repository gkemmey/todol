Rails.application.routes.draw do
  root "site#home"

  resources :lists, shallow: true, except: [:new, :edit] do
    resources :todos, except: [:index, :new, :show] do
      # todo: update many
    end

    # todo: share it
  end
end
