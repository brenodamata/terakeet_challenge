class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
  belongs_to :genre

  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats

  validates :title, presence: true
  validates :genre_id, presence: true
  validates :author_id, presence: true
  validates :publisher_id, presence: true
end
