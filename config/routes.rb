Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ctlinks 
  resources :nodes do
    resources :posts
  end
  resources :posts do
    collection {post :import}
    collection {get :api}
    collection {get :dashboard}
  end
  resources :links
  root to: "links#index"
end
