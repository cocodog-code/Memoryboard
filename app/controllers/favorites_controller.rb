class FavoritesController < ApplicationController
  before_action :require_logged_in
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    favorite = current_user.favorites.build(micropost_id: params[:micropost_id])
    favorite.save
    respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
  end
  
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    # current_user.favorites.find_by(micropost_id: params[:micropost_id]).destroy
    favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
    favorite.destroy
    respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
  end
end
