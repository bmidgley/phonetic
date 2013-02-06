class BooksController < ApplicationController
  before_filter :access_for_editor, :except => [:index, :show]
  before_filter :protect_this, :only => [:index, :show]
  
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    @book.user = current_user.dictionary_for
    if @book.user && @book.save
      flash[:notice] = "Successfully created book."
      redirect_to books_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.user == current_user || current_user.is_admin
      if @book.update_attributes(params[:book])
        flash[:notice] = "Successfully updated book."
        redirect_to books_url
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = "Access denied"
    end
  end
  
  def destroy
    @book = Book.find(params[:id])
    if @book.user == current_user || current_user.is_admin
      @book.destroy
      flash[:notice] = "Successfully destroyed book."
    else
      flash[:notice] = "Access denied"
    end
    redirect_to books_url
  end

  def show
    @book = Book.find(params[:id])
    @mark = Bookmark.user(current_user).book(@book).farthest.first ||
      current_user.bookmarks.create!(:book => @book, :start => 0)
    
    size = 1200
    
    if params[:offset]
      @start = params[:offset].to_i rescue 0
      @start = 0 if @start < 0
      @mark.update_attributes(:start => @start)
    else
      @start = @mark.start
    end
    
    require 'patron'
    session = Patron::Session.new
    response = session.get(@book.url, {"Range" => "bytes=#{@start}-#{@start + size}"})
    @content = response.body
    @translation = Conversion.convert(@content, current_user)
    @split_content = @content.split("\n")
    @split_translation = @translation.split("\n")
    
    @show_original = params[:original]
    @show_translation = params[:translation]

    # next page offset, chop the last (incomplete) line
    @forward_offset = @start + @content.size - @split_content[-1].size
    @back_offset = @start - size
  end
  
  def index
    @books = Book.for_user(current_user.dictionary_user || current_user)
  end
end
