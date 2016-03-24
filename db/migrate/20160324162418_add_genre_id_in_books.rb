class AddGenreIdInBooks < ActiveRecord::Migration
  def change
    add_reference :books, :genre, index: true
  end
end
