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

  def format_types
    book_format_types.map(&:name).join(', ')
  end

  def author_name
    self.author.last_name_first
  end

  def average_rating
    book_reviews.map(&:rating).inject(0) { |sum, x| sum + x }.to_f / book_reviews.size
  end
end
