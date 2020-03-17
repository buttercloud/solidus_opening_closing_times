Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :stores do
      resources :working_days, only: [:index, :create, :edit, :destroy] do
        resources :working_hours, only: [:create, :destroy]
      end
    end
  end
end
