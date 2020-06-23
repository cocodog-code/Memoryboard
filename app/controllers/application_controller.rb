class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
  
  #beforeアクション
    def require_logged_in
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end
end
