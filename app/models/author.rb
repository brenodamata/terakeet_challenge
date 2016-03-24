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
end
