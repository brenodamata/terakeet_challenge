class BookFormat < ActiveRecord::Base
  belongs_to :book
  belongs_to :book_format_type

  validates :book_id, presence: true
  validates :book_format_id, presence: true
end
