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
    BookFormat.create(book: book, book_format_type: (create :kindle))
    BookFormat.create(book: book, book_format_type: (create :paperback))
    expect(book.format_types).to include("Kindle")
    expect(book.format_types).to include("Paperback")
  end

  it 'returns all books if no query on search' do
    BookReview.create(book: (create :book), rating: 5)
    books = Book.search(nil, nil)
    expect(Book.all_by_rating("DESC")).to eq(books)
  end

  it 'orders by rating from high to low' do
    book = create :book
    BookReview.create(book_id: book.id, rating: 5)
    book2 = create :book2
    BookReview.create(book_id: book2.id, rating: 4)

    books = Book.search(nil, nil)
    expect(books.first).to eq(book)
    expect(books.last).to eq(book2)
  end

  it 'returns books by title search' do
    book = create :book
    BookReview.create(book: book, rating: 5)
    books = Book.search(book.title,nil)
    expect(books).to include(book)
  end

  it 'returns books by part title search' do
    book = create :book
    query = book.title.split(' ')[0].upcase
    BookReview.create(book: book, rating: 5)
    books = Book.search(query,nil)
    expect(books).to include(book)
  end

  it 'returns search only by title' do
    book = create :book
    BookReview.create(book: book, rating: 5)
    books = Book.search(book.publisher.name.upcase,{title_only:true})
    expect(books).not_to include(book)
  end

  it 'returns search by author\'s exact last name (case insensitive)' do
    book = create :book
    BookReview.create(book: book, rating: 5)
    books = Book.search(book.author.last_name.upcase,{title_only:false})
    expect(books).to include(book)
  end

  it 'returns search by publisher\'s exact name (case insensitive)' do
    book = create :book
    BookReview.create(book: book, rating: 5)
    books = Book.search(book.publisher.name.upcase,{title_only:false})
    expect(books).to include(book)
  end

  it 'returns search only for selected type formats' do
    book = create :book
    book2 = create :book2
    BookReview.create(book: book, rating: 5)
    BookReview.create(book: book2, rating: 5)
    kindle = create :kindle
    BookFormat.create(book: book, book_format_type: kindle)
    BookFormat.create(book: book, book_format_type: (create :pdf))
    BookFormat.create(book: book2, book_format_type: (create :paperback))
    books = Book.search("",{book_format_type_id:[kindle.id]})
    expect(books).to include(book)
    expect(books).not_to include(book2)
  end

  it 'returns search only for physical books' do
    digital = create :book
    physical = create :book2
    BookReview.create(book: digital, rating: 5)
    BookReview.create(book: physical, rating: 5)
    BookFormat.create(book: digital, book_format_type: (create :pdf))
    BookFormat.create(book: physical, book_format_type: (create :paperback))
    books = Book.search("",{book_format_physical:true})
    expect(books).to include(physical)
    expect(books).not_to include(digital)
  end

  it 'returns search only for digital books' do
    digital = create :book
    physical = create :book2
    BookReview.create(book: digital, rating: 5)
    BookReview.create(book: physical, rating: 5)
    BookFormat.create(book: digital, book_format_type: (create :pdf))
    BookFormat.create(book: physical, book_format_type: (create :paperback))
    books = Book.search("",{book_format_physical:false})
    expect(books).not_to include(physical)
    expect(books).to include(digital)
  end

end
