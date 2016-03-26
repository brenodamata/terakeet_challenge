class BooksController < ApplicationController
  def index
    if params[:book].nil?
      options = nil
    else
      options = get_options(params[:title_only], params[:physical], params[:book][:book_format_type_ids])
    end

    @books = Book.search(params[:search], options).paginate(:page => params[:page], :per_page => 10)
  end

protected

  def get_options(title_only, physical, format_type_ids)
    options = {}
    options[:title_only] = true unless title_only.nil?
    options[:book_format_type_id] = format_type_ids[0..-2] if format_type_ids.size > 1
    unless physical.nil?
      physical == 'yes' ? options[:book_format_physical] = true : options[:book_format_physical] = false
    end
    if options.empty?
      return nil
    else
      return options
    end
  end
end
