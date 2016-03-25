Rails.application.routes.draw do
  root 'books#index'
  post 'books', to: 'books#search'
end
