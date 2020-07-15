class PasswordEditsController < ApplicationController
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    #現在のパスワードが一致しない場合はeditをrenderして終了
    unless @user.authenticated?(:password, params[:user][:current_password])
      flash.now[:danger] = "Incorrect password"
      render 'edit'
      return
    end
    
    if @user.update_attributes(user_params)
        flash[:success] = "Password changed"
        redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
end