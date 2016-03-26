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

  def digital_only?

  end


# The results should be ordered by average rating, with the highest rating first.
# The list should be unique (the same book shouldn't appear multiple times in the results)
  def self.search(query, options)
    byebug
    if query
      if options.nil?
        title_only = false
        type_ids, physical = nil
      else
        options[:title_only] ? title_only = true : title_only = false
        options[:book_format_type_id] ? type_ids = options[:book_format_type_id] : type_ids = nil
        if options[:book_format_physical].nil?
          physical = nil
        else
          physical = options[:book_format_physical]
        end
      end

      conditions =  condition_query(title_only)

      if !physical.nil? and type_ids
        # only book formats selected and acording to it's physical boolean
        ids = options[:book_format_type_id].map(&:to_i) & BookFormatType.where(physical: physical).pluck(:id)
      elsif physical.nil? and type_ids
        # only book formats selected
        ids = options[:book_format_type_id].map(&:to_i)
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
    else
      all
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
