require 'date'
class BooksController < ApplicationController
  private

  def book_params
    params.require(:book).permit(:ISBN, :title, :author, :language, :bookname,
                                  :published, :edition, :image, :subject,
                                  :summary, :specialcollection, :library_id, :copies)
  end
  public

  def index
    if session[:role] == "student"
      @library = Library.find_by_university_id(session[:university_id])
      @book = Book.where(library_id: @library[:library_id])
    else
      @book = Book.where("library_id = " + session[:library])
  end 
  end


  def book_bookmark
    @bookmark = Bookmark.new(:student_id => session[:student_id], :ISBN => params[:ISBN])
    if !Bookmark.find_by_student_id_and_ISBN(session[:student_id],params[:ISBN])
      @bookmark.save
    end
    puts "yey"
    flash[:notice] = "Bookmarked !!!"
    redirect_to :controller => 'students', :action => 'index'

  end

 def checkout
    @student = Student.find_by_id(session[:student_id])

    if Transaction.find_by_student_id(session[:student_id])
      @tran = Transaction.find_by_student_id(session[:student_id])
      m = Transaction.where(student_id: @tran[:student_id]).count

      if @student[:maximum_book_limit].to_i > m
        @book = Book.find_by_ISBN(params[:ISBN])
        
        now = Date.today
        max_day = Library.find_by_library_id(@book[:library_id].to_i)[:max_days]
        after = now + max_day.to_i
        
        copies = @book[:copies]
        if (copies.to_i > 0)
          ####special request###
            if @book[:specialcollection] == "yes"
              @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "approval request", :library_id => @book[:library_id])
              @trn.save
              flash[:notice] = "Request sent to librarian for approval"
              redirect_to :controller => 'students', :action => 'index'
              #####special request###
            else
              @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "checked out", :library_id => @book[:library_id], :checkout_date => now, :expected_date => after)
              @trn.save
              @book.update_attribute(:copies, (copies.to_i-1).to_s)
              flash[:notice] = "Book checked out successfully"
              redirect_to :controller => 'students', :action => 'index'
            end
        else
          ## when book is not available...... libid is string and studid is integer
          @hld = Hold.new(:student_id => session[:student_id], :ISBN => params[:ISBN], :library_id => @book[:library_id])
          @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "hold request", :library_id => @book[:library_id])
          @hld.save
          @trn.save
          flash[:notice] = "Book not available. Hold request added"
          redirect_to :controller => 'students', :action => 'index'
        end
      else
        flash[:notice] = "Maximum books limit excedded"
        redirect_to :controller => 'students', :action => 'index'
      end
    else
      ###first transaction
      @book = Book.find_by_ISBN(params[:ISBN])
      now = Date.today
      max_day = Library.find_by_library_id(@book[:library_id].to_i)[:max_days]
      after = now + max_day.to_i
      copies = @book[:copies]
        if (copies.to_i > 0)
            if @book[:specialcollection] == "yes"
                    @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "approval request", :library_id => @book[:library_id])
                    @trn.save
                    flash[:notice] = "Request sent to librarian for approval"
                    redirect_to :controller => 'students', :action => 'index'
                #####special request###
            else
                copies = @book[:copies]
                @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "checked out", :library_id => @book[:library_id], :checkout_date => now, :expected_date => after)
                @trn.save
                @book.update_attribute(:copies, (copies.to_i-1).to_s)
                flash[:notice] = "Book checked out successfully"
                redirect_to :controller => 'students', :action => 'index'
            end
        else
            @hld = Hold.new(:student_id => session[:student_id], :ISBN => params[:ISBN], :library_id => @book[:library_id])
            @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "hold request", :library_id => @book[:library_id])
            @hld.save
            @trn.save
            flash[:notice] = "Book not available. Hold request added"
            redirect_to :controller => 'students', :action => 'index'
        end
   end
 end

=begin
def bsearch
    if params[:subject] != nil
        if params[:title] != nil
                if params[:author] != nil
                  @book = Book.where(subject: params[:search][:subject],title: params[:search][:title],author: params[:search][:author])
                else
                  @book = Book.where(subject: params[:search][:subject],title: params[:search][:title])
                end
        elsif params[:search][:author] != nil
                @book = Book.where(author: params[:search][:author])
        else
             @book = Book.where(title: params[:search][:title])
        end
  elsif params[:title] != nil
        if params[:search][:author] != nil
                  @book = Book.where(title: params[:search][:title],author: params[:search][:author])
        else
                  @book = Book.where(title: params[:search][:title])
        end
  elsif params[:author] != nil
         @book = Book.where(author: params[:search][:author])
  end
       
  puts "***********88"
  puts "I am done"
  puts "***************" 
end
=end
def search
  if params[:subject] != ""
        if params[:title] != ""
                if params[:author] != ""
                  @book = Book.where(subject: params[:subject],title: params[:title],author: params[:author])
                else
                  @book = Book.where(subject: params[:subject],title: params[:title])
                end
        elsif params[:author] != ""
                @book = Book.where(subject: params[:subject],author: params[:author])
        else
             @book = Book.where(subject: params[:subject])
        end
  elsif params[:title] != ""
        if params[:author] != ""
                  @book = Book.where(title: params[:title],author: params[:author])
        else
                  @book = Book.where(title: params[:title])
        end
  elsif params[:author] != ""
         @book = Book.where(author: params[:author])
  end
       
  
end


  def destroy

    @book = Book.find_by_id(params[:format])
    puts @book[:id]
    @book.destroy
    redirect_to books_path
  end

  def show
    @book = Book.find_by_ISBN(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @book }
    end
  end


  def new
    @book = Book.new

    respond_to do |format|
      format.html
      format.json { render json: @book }
    end
  end

  def create
    @book = Book.new(book_params)
    uploaded_to = params[:book][:image_url]
    @book[:library_id] = session[:library]
    @book[:specialcollection] = params[:specialcollection]
    puts "cccccccccccccccc$$$$$$$$"
    puts @book[:specialcollection]
    puts "#^^^^^^^^^^^666"
    @book[:image] = "asofnow"

    respond_to do |format|
      if @book.save
        format.html { redirect_to :controller => 'librarians', :action => 'index' }
        flash[:notice] = "Book Added successfully"

      else
        flash[:notice] = "Book not added.. please try again!"
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @book = Book.find_by_ISBN_and_library_id(params[:id], session[:library])

  end
  def update
    @book = Book.find_by_id(params[:id])

    respond_to do |format|
      if @book.update_attributes(book_params)
        format.html { redirect_to :controller => 'books', :action => 'index' }
        flash[:notice] = "Book Info was successfully updated."
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end


end
