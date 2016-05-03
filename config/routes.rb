Rails.application.routes.draw do
 
  devise_for :users
  resources :users, only: [:update, :show, :index]

  resources :topics do
    resources :posts, except: [:index], controller: 'topics/posts'
  end

  resources :posts, only: [:index] do
    resources :comments, only: [:create, :destroy]

    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote

    post '/favorite' => 'favorites#favorite', as: :favorite
    post '/unfavorite' => 'favorites#unfavorite', as: :unfavorite

  end

  get 'about' => 'welcome#about'

  root to: 'welcome#index'
end
