class BooksController < ApplicationController
  def index
    @books = Book.paginate(:page => params[:page], :per_page => 10)
    @book = Book.new # for search
  end

  def search
    @query = params[:book][:title]
    @books = Book.search(@query, nil).paginate(:page => params[:page], :per_page => 10)
    @book = Book.new # for search
  end
end
