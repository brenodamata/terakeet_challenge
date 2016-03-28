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
  it 'has average rating' do
    book = create :book
    BookReview.create(book_id: book.id, rating: 5)
    BookReview.create(book_id: book.id, rating: 4)
    expect(book.average_rating).to be 4.5
  end
  it 'has author name' do
    book = build :book
    expect("#{book.author.last_name}, #{book.author.first_name}").to eq(book.author_name)
  end
  it 'has format types' do
    book = create :book
    kindle = create :kindle
    paperback = create :paperback
    BookFormat.create(book: book, book_format_type: kindle)
    BookFormat.create(book: book, book_format_type: paperback)
    expect(book.format_types).to include("Kindle")
    expect(book.format_types).to include("Paperback")
  end

  it 'returns all books if no query on search' do
    BookReview.create(book: (create :book), rating: 5)
    books = Book.search(nil, nil)
    expect(Book.all).to eq(books)
  end

  it 'orders by rating from high to low' do
    book = create :book
    BookReview.create(book_id: book.id, rating: 5)
    book2 = create :book2
    BookReview.create(book_id: book2.id, rating: 4)

    books = Book.search(nil, nil)
    expect(books.first).to eq(Book.highest_rating)
    expect(books.last).to eq(Book.lowest_rating)
  end

end
