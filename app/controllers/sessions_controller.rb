class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    auth = request.env['omniauth.auth']
    #Facebookログイン
    if auth.present?
      if user = User.find_or_create_from_auth(request.env['omniauth.auth'])
        session[:user_id] = user.id
        redirect_back_or user
      else
        redirect_to auth_failure_path
      end
    #既存パタン
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user&.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end