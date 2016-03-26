class BookFormatType < ActiveRecord::Base
  has_many :book_formats
  has_many :books, -> { distinct }, through: :book_formats

  validates :name, presence: true
  validates :name, uniqueness: true

  before_create :set_defualt_physical

  protected

  def set_defualt_physical
     self.physical = true if self.physical.nil?
   end
end
