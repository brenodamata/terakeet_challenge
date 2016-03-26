class Genre < ActiveRecord::Base
  has_many :books
  validates :name, presence: true
  validates :name, uniqueness: true

  def books_by_rating
    self.books.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).group("books.id").order("rating DESC")
  end
end
