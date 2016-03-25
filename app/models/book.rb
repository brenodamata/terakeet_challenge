class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
  belongs_to :genre

  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats

  validates :title, presence: true
  validates :genre_id, presence: true
  validates :author_id, presence: true
  validates :publisher_id, presence: true

  def format_types
    book_format_types.map(&:name).join(', ')
  end

  def author_name
    self.author.last_name_first
  end

  def average_rating
    book_reviews.map(&:rating).inject(0) { |sum, x| sum + x }.to_f / book_reviews.size
  end

# Returns a collection of books that match the query string, subject to the following rules:
# 1. If the last name of the author matches the query string exactly (case insensitive)
# 2. If the name of the publisher matches the query string exactly (case insensitive)
# 3. If any portion of the book’s title matches the query string (case insensitive)
# The results should be the union of books that match any of these three rules.
# The results should be ordered by average rating, with the highest rating first.
# The list should be unique (the same book shouldn't appear multiple times in the results)
# Search options:
# :title_only(defaults to false).
#     If true, only return results from rule #3 above.
# :book_format_type_id(defaults to nil).
#     If true, only return books that are available in a format that matches the supplied type id.
# :book_format_physical(defaults to nil).
#     If supplied as true or false, only return books that are available in a format whose “physical”
#     field matches the supplied argument. This filter is not applied if the argument is not present or nil.
# Book.search('',{:title_only=>true, :book_format_type_id=>[151,157,160], :book_format_physical=>true})
  def self.search(query, options)
    options[:title_only] ? title_only = true : title_only = false
    options[:book_format_type_id] ? type_ids = options[:book_format_type_id] : type_ids = nil
    options[:book_format_physical] ? physical = options[:book_format_physical] : physical = nil

    conditions =  condition_query(title_only)

    if !physical.nil? and type_ids
      # only book formats selected and acording to it's physical boolean
      ids = options[:book_format_type_id] & BookFormatType.where(physical: physical).pluck(:id)
    elsif physical.nil? and type_ids
      # only book formats selected
      ids = options[:book_format_type_id]
    elsif !physical.nil? and type_ids.nil?
      # only the book formats acording to it's physical boolean
      ids = BookFormatType.where(physical: physical).pluck(:id)
    else
      ids = nil
    end

    begin
      if title_only and ids.nil?
        find(:all, :conditions => conditions)
      elsif !title_only and ids.nil?
        self.joins(:author).joins(:publisher).where(conditions, "%#{query.downcase}%", query.downcase, query.downcase)
      elsif title_only and ids
        self.joins(:book_format_types).where("book_format_types.id IN (#{ids.join(', ')})")
      elsif !title_only and ids
        conditions = "(#{conditions}) AND book_format_types.id IN (#{ids.join(', ')})"
        self.joins(:author).joins(:publisher).joins(:book_format_types).where(conditions, "%#{query.downcase}%", query.downcase, query.downcase)
      end
    rescue
      Book.none # Did not find any books matching search criteria
    end
  end

private

  def self.title_conditions
    "lower(books.title) LIKE ?"
  end

  def self.author_conditions
    "lower(authors.last_name) = ?"
  end

  def self.publisher_conditions
    "lower(publishers.name) = ?"
  end

  def self.condition_query title_only
    title_only ? title_conditions : [title_conditions, author_conditions, publisher_conditions].join(' OR ')
  end

end
