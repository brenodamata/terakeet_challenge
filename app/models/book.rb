class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
  belongs_to :genre

  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, -> { distinct }, through: :book_formats

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

  def self.search(query, options)
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
          self.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).where(conditions, "%#{query.downcase}%").group("books.id").order("rating DESC")
        elsif !title_only and ids.nil?
          self.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).joins(:author).joins(:publisher).where(conditions, "%#{query.downcase}%", query.downcase, query.downcase).group("books.id").order("rating DESC")
        elsif title_only and ids
          conditions += " AND book_format_types.id IN (#{ids.join(', ')})"
          self.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).joins(:book_format_types).where(conditions, "%#{query.downcase}%").group("books.id").order("rating DESC")
        elsif !title_only and ids
          conditions = "(#{conditions}) AND book_format_types.id IN (#{ids.join(', ')})"
          self.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).joins(:author).joins(:publisher).joins(:book_format_types).where(conditions, "%#{query.downcase}%", query.downcase, query.downcase).group("books.id").order("rating DESC")
        end
      rescue
        none # Did not find any books matching search criteria
      end
    else
      all_by_rating "DESC"
    end
  end

  def self.highest_rating
    all_by_rating("DESC").first
  end

  def self.lowest_rating
    all_by_rating("ASC").first
  end

  def self.all_by_rating order
    self.select("DISTINCT books.*, AVG(book_reviews.rating) AS rating").joins(:book_reviews).group("books.id").order("rating #{order}")
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
