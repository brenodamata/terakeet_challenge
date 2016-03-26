class BooksController < ApplicationController
  def index
    @books = Book.search(params[:search],nil).paginate(:page => params[:page], :per_page => 10)
    @book = Book.new # for search
  end
end
