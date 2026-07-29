Rails.application.routes.draw do
  root "feed#index"

  resources :posts, only: [:create, :show, :destroy] do
    member do
      post :react
      get :analytics
    end
    resources :comments, only: [:create], shallow: true
  end
  resources :comments, only: [:destroy] do
    member { post :like }
  end

  resource :my_persona, only: [:edit, :update], controller: "my_personas"
  resources :personas, only: [:show] do
    member { post :endorse }
  end

  get "network" => "network#index"
  resources :connections, only: [:create, :update]

  get "notifications" => "notifications#index"

  resources :jobs, only: [:index, :new, :create] do
    member { post :apply }
  end

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  post "ai/enhance" => "ai#enhance"

  delete "admin/posts/:id" => "admin#destroy_post", as: :admin_post
  delete "admin/personas/:id" => "admin#destroy_persona", as: :admin_persona

  get "up" => "rails/health#show", as: :rails_health_check
end
