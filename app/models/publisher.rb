class Publisher < ActiveRecord::Base
  has_many :books

  validates :name, presence: true
  validates :name, uniqueness: true
end
