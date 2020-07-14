class FavoritesController < ApplicationController
  before_action :require_logged_in
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.like(current_user)
    # micropost = Micropost.find(params[:micropost_id])
    micropost.create_notification_like!(current_user)
    respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
  end
  
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.unlike(current_user)
    respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
  end
end
