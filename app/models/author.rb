class Author < ActiveRecord::Base
  has_many :books

  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def last_name_first
    "#{last_name}, #{first_name}"
  end

  def books_by_rating
    self.books.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).group("books.id").order("rating DESC")
  end
end
