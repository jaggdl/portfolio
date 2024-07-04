Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "(:locale)", locale: /en|es/ do
    # Defines the root path route ("/")
    root "application#index"

    resources :posts, path: 'blog', param: :id do
      member do
        get 'og_image'
      end
    end

    get 'analytics', to: 'analytics#index'
  end

  # Define routes without locale
  root to: 'application#index', as: :unlocalized_root

  namespace :connection do
    resources :out
    resources :set

    resources :in do
      member do
        patch :approve
      end
    end
  end

  resources :connections

  namespace :api do
    namespace :v1 do
      resources :connection do
        member do
          get 'public_info'
        end
      end
    end
  end

  resources :users, only: [:new, :create]
end
