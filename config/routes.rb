Rails.application.routes.draw do
  root "feed#index"

  resources :posts, only: [ :create, :show, :destroy ] do
    member do
      post :react
      post :hype
      post :save
      post :report
      post :mog
      post :vote
      get :analytics
    end
    resources :comments, only: [ :create ], shallow: true
  end
  resources :comments, only: [ :destroy ] do
    member { post :like }
  end

  resource :my_persona, only: [ :edit, :update ], controller: "my_personas" do
    post :regenerate
    post :verify
  end
  post "ai/larpmaxx" => "ai#larpmaxx"
  resources :personas, only: [ :show ] do
    member { post :endorse }
  end

  resources :articles, path: "news", only: [ :index, :show, :new, :create, :destroy ]
  resources :experiences, only: [ :create, :destroy ]
  resources :profile_skills, only: [ :create, :destroy ]
  resources :certifications, only: [ :create ]

  get "signup" => "accounts#new"
  post "signup" => "accounts#create"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  get "saved" => "saved_posts#index"
  get "premium" => "premium#show"
  post "premium/activate" => "premium#activate"
  get "profile-views" => "profile_views#index", as: :profile_views
  get "search" => "search#index"

  get "larpboard" => "larpboard#index"
  get "network" => "network#index"
  resources :connections, only: [ :create, :update ]

  get "notifications" => "notifications#index"

  resources :jobs, only: [ :index, :new, :create ] do
    member { post :apply }
  end

  resources :conversations, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ]
  end

  post "ai/enhance" => "ai#enhance"

  get "admin/ai" => "admin#ai_status", as: :admin_ai
  delete "admin/posts/:id" => "admin#destroy_post", as: :admin_post
  delete "admin/personas/:id" => "admin#destroy_persona", as: :admin_persona

  get "up" => "rails/health#show", as: :rails_health_check
end
