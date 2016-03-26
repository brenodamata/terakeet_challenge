Rails.application.routes.draw do
  root 'books#index'
  get 'books', to: 'books#index'

  get 'publisher/:publisher_id/books', to: 'books#publisher', as: 'publisher_books'
  get 'genre/:genre_id/books',         to: 'books#genre',     as: 'genre_books'
  get 'author/:author_id/books',       to: 'books#author',    as: 'author_books'
end
