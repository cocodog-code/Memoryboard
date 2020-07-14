class CommentsController < ApplicationController
  before_action :require_logged_in, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @micropost.create_notification_comment!(current_user, @comment.id)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
  
  private
  
    def comment_params
      params.require(:comment).permit(:content, :micropost_id, :user_id)
    end
    
    #自分自身のコメントのみ削除可能とする
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
