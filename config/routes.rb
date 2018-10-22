Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_activity', on: :member
  end
  resources :beers
  resources :places, only: [:index, :show]
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :styles
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'

  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'

  get 'auth/:provider/callback', to: 'sessions#create_oauth'
  post 'auth/github', to: 'sessions#gitbutton'
  root 'breweries#index'
  
end
