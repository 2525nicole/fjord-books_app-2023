Rails.application.routes.draw do
  resources :comments
  resources :reports do
    resources :comments, only: [:create], module: :reports
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    resources :comments, only: [:create], module: :books
  end
  resources :users, only: %i(index show)
end
