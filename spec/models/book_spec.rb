require "rails_helper"

RSpec.describe Book, :type => :model do
  it "is valid" do
    new_book = build :book
    expect(new_book).to be_valid
  end
  it "is invalid without a title" do
    new_book = build :book, :titleless
    expect(new_book).to be_invalid
    expect(new_book.errors[:title]).to include("can't be blank")
  end
  it "is invalid without a author" do
    new_book = build :book, :no_author
    expect(new_book).to be_invalid
    expect(new_book.errors[:author_id]).to include("can't be blank")
  end
  it "is invalid without a publisher" do
    new_book = build :book, :no_publisher
    expect(new_book).to be_invalid
    expect(new_book.errors[:publisher_id]).to include("can't be blank")
  end
  it "is invalid without a genre" do
    new_book = build :book, :no_genre
    expect(new_book).to be_invalid
    expect(new_book.errors[:genre_id]).to include("can't be blank")
  end
  it 'has a rating' do
    review = build :book_review, :rating5
    expect(review.rating).to be 5
  end
end
