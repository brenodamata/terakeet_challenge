namespace :db do
  puts "Fill database with sample data"

  task populate: :environment do
    require 'populator'
    require 'faker'

    # call this method to delete only selected models
    delete_records [BookFormat, BookFormatType, BookReview, Book, Author, Publisher, Genre]

    create_publishers 100
    create_genres
    create_format_types

    10000.times do
      author = Author.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

      rand(1..5).times do
        book = Book.create(title: Faker::Book.title,
                           publisher: get_random_publisher,
                           author: author,
                           genre: get_random_genre)

        BookReview.populate 100 do |review|
          review.book_id = book.id
          review.rating = rand(1..5)
        end

        BookFormat.populate rand(1..10) do |format|
          format.book_id = book.id
          format.book_format_type_id = get_random_book_format_type.id
        end
      end
    end
  end

  def delete_records models
    models.each(&:delete_all)
  end

  def create_publishers number
    Publisher.populate number do |publisher|
      publisher.name = Faker::Company.name
    end
  end

  def create_genres
    ['Classic', 'Comic/Graphic Novel', 'Crime/Detective', 'Fable', 'Fairy tale',
     'Fanfiction', 'Fantasy', 'Fiction narrative', 'Fiction in verse', 'Folklore',
     'Historical fiction', 'Horror', 'Humor', 'Legend', 'Metafiction', 'Mystery',
     'Mythology', 'Mythopoeia', 'Realistic fiction', 'Science fiction ', 'Short story',
     'Suspense/Thriller', 'Tall tale', 'Western', 'Biography/Autobiography', 'Essay',
     'Narrative nonfiction', 'Speech', 'Textbook', 'Reference book'].each { |genre| Genre.create(name: genre) }
  end

  def create_format_types
    {Hardcover: true, Softcover: true, Kindle: false, PDF: false,
     Audiobook: false, Bunkobon: true, Chapbook: true, Paperback: true,
     Folio: true, Octavo: true}.each { |type, physical| BookFormatType.create(name: type, physical: physical) }
  end

  def get_random_publisher
    Publisher.offset(rand(Publisher.count)).first
  end

  def get_random_genre
    Genre.offset(rand(Genre.count)).first
  end

  def get_random_book_format_type
    BookFormatType.offset(rand(BookFormatType.count)).first
  end

end

