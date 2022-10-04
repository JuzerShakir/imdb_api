Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :entertainment
    end
  end
end
