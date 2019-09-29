class BooksController < ApplicationController
  private

  def book_params
    params.require(:book).permit(:ISBN, :title, :author, :language, :bookname,
                                  :published, :edition, :image, :subject,
                                  :summary, :specialcollection, :library, :copies)
  end
  public

  def index
    if session[:role] == "student"
      puts "#&&&&&"
      puts session[:university_id]
      puts "#&&&&&&"
      @lib = Library.find_by_university_id(session[:university_id])
      #@stud = Student.find_by_student_id(session[:student_id])
      #puts @stud[:univer]
      puts  @lib
      puts "$$$$"
      @book = Book.where(library_id: @lib[:library_id])
    else
      @book = Book.where("library_id = " + session[:library])
  end
   
  end


  def checkout
    @stud = Student.find_by_id(session[:student_id])
    #puts session[:student_id]
    #puts @stud
    #puts "******"
    if Transaction.find_by_student_id(session[:student_id])
      @tran = Transaction.find_by_student_id(session[:student_id])
      #puts Transaction.where(student_id: @tran[:student_id])
      m = Transaction.where(student_id: @tran[:student_id]).count
      #puts m
      if @stud[:maximum_book_limit].to_i > m
        #puts "&&&&&&"
        puts params[:ISBN]
        #puts "******"
        @trn = Transaction.new(:student_id => session[:student_id],:bookname => params[:bookname], :ISBN => params[:ISBN], :status => "checked out")
        @trn.save
        redirect_to :controller => 'students', :action => 'index'
      else
        flash[:notice] = "Maximum books limit excedded"
        redirect_to :controller => 'students', :action => 'index'
      end
    else
        @trn = Transaction.new(:student_id => session[:student_id], :bookname => params[:bookname], :ISBN => params[:ISBN], :status => "checked out")
        @trn.save
        redirect_to :controller => 'students', :action => 'index'
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
    params[:book][:specialcollection] = params[:specialcollection]

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
