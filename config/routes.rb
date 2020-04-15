Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/fin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :farms
  resources :pablos
  resources :pages
  resources :ctlinks 
  resources :domains do
    resources :nodes
  end  
  resources :nodes do
    resources :posts
  end
  resources :posts do
    collection {post :import}
    collection {post :youtube_import}
    collection {post :ptt_import}
    collection {get :api}
    collection {get :dashboard}
    collection {get :search}
    collection {get :news}
  end
  resources :links
  root to: "posts#index"
end
