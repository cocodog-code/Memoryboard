class UsersController < ApplicationController
  before_action :require_logged_in, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Memoryboard!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    #プロフィール画面から自身のアカウントを削除する場合
    if request.referrer == edit_user_url
      if current_user?(@user)
        @user.destroy
        flash[:success] = "Account deleted"
        redirect_to root_url
      else
        redirect_to root_url
      end
    #adminユーザーが他のユーザーのアカウントを削除する場合
    elsif
      request.referrer == users_url
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    else
      redirect_to root_url
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:full_name, :user_name, :email,
                                   :website, :introduction, :phone_number,
                                   :gender, :password,:password_confirmation)
    end
    
    #beforeアクション
    def require_logged_in
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
