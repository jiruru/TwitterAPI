Rails.application.routes.draw do
  get 'hoge/index'

  devise_for :users
  get 'home/index'
  get 'home/show'     => 'home#show'
  root 'home#index'

  post 'home/new'     => 'home#new'
  post 'home/show'    => 'home#show'
  post 'home/destroy' => 'home#destroy'

  get '*unmatched_route', to: 'home#index'
end
