# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_commentable, only: %i[edit create update destroy]

  def edit
    return if created_by?(@comment)

    redirect_to @commentable, notice: t('controllers.alert.unable_to_edit')
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    return unless @comment.save

    redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def update
    return unless created_by?(@comment)

    if @comment.update(comment_params)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless created_by?(@comment)

    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
