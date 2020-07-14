class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page]).search(params[:search])
      @comment = Comment.new
      @comments = @micropost.comments
    end
  end
end
