# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable, only: %i[create destroy update edit]
  #before_action :set_commentable_link, only: %i[destory]

  # GET /books or /books.json
  # def index
  #   @comments = Comment.all#.order(:id).page(params[:page]) if comment.commentable_type == "Book"
  #   @comments = "テスト"
  #     render "books/show"
  #     render "comments/comment"
  # end

  # GET /books/1 or /books/1.json bookのまま
  # def show; end

  # GET /books/new
  # def new
  #   @comment = Comment.new
  #   render 'comments/new' # renderだと上が実行されない?
  # end

  # GET /books/1/edit bookのまま
  #def edit; end

  # POST /books or /books.json
  # def create
  #   @comment = @book.comments.build(comment_params)
  #   @comment.user = current_user

  #   if @comment.save
  #     redirect_to book_url(@book), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  #   #else
  #     # redirect_to book_url(@book), notice: "投稿に失敗しました"
  #     # render template: "books/show", status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /books/1 or /books/1.json bookのまま
  # def update
  #   respond_to do |format|
  #     if @book.update(book_params)
  #       format.html { redirect_to book_url(@book), notice: t('controllers.common.notice_update', name: Book.model_name.human) }
  #       format.json { render :show, status: :ok, location: @book }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @book.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /books/1 or /books/1.json bookのまま
  # def destroy
  #   super
  #   redirect_to book_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  # end
  #   respond_to do |format|
  #     format.html { redirect_to books_url, notice: t('controllers.common.notice_destroy', name: Book.model_name.human) }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:content)
  end

  # def set_commentable_link
  #   @commentable = Book.find(@comment.commentable_id)
  # end
end
