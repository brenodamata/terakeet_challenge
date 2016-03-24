namespace :db do
  puts "Fill database with sample data"

  task populate: :environment do
    # require 'populator'
    # require 'faker'

    # delete only selected
    # delete_records [Author, Publisher, Genre, Review, BookFormat, BookFormatType, Book]

    # create_publishers 100
    # create_genres
    # create_format_types

    # Author.populate 100000 do |author|
    #   author.first_name = Faker::Name.first_name
    #   author.last_name = Faker::Name.last_name

    #   Book.populate 1..5 do |book|
    #     Book.name = Faker::Book.title
    # end


    # Publisher.populate 100 do |publisher|
    #   category.name = Populator.words(1..2).titleize
    #   Product.populate 10..100 do |product|
    #     product.category_id = category.id
    #     product.name = Populator.words(1..5).titleize
    #     product.description = Populator.sentences(2..10)
    #     product.price = [4.99, 19.95, 100]
    #     product.created_at = 2.years.ago..Time.now
    #   end
    # end
  end

  def delete_records models
    modeles.each(&:delete_all)
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
    ['Hardcover', 'Softcover', 'Kindle', 'PDF']
  end

end

