Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/fin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :farms
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
    collection {get :api}
    collection {get :dashboard}
  end
  resources :links
  root to: "links#index"
end
