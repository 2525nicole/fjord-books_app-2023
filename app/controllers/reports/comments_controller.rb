class Reports::CommentsController < CommentsController
  before_action :set_commentable, only: %i[create]
  #before_action :post_user?, only: %i[ show edit ]

  # GET /comments or /comments.json
  # def index
  #   @comments = Comment.order(:id).page(params[:page])
  # end

  # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end

  # POST /comments or /comments.json
  # def create
  #   @comment = @report.comments.build(comment_params)
  #   @comment.user = current_user

  #   if @comment.save
  #     redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  #     # else
  #     #   render :new, status: :unprocessable_entity
  #     # end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commentable
      @commentable = Report.find(params[:report_id])
    end

    # def post_user?
    #   @comment.user == current_user
    # end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
