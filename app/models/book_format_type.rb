class BookFormatType < ActiveRecord::Base
  has_many :book_formats
  has_many :books, through: :book_formats

  validates :name, presence: true

  before_create :set_defualt_physical

  protected

  def set_defualt_physical
     self.physical = true if self.physical.nil?
   end
end
