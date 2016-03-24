class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
end
