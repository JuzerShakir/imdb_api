Rails.application.routes.draw do
  namespace :api do
    resource :entertainment, only: [:create, :update]
  end
end
