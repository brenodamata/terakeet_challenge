class BookReview < ActiveRecord::Base
  belongs_to :book

  validates :book_id, presence: true
  validates :rating, presence: true
end
