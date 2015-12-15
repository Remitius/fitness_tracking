class SessionsController < ApplicationController
  def create
    if logged_in?
      flash[:error] = 'You are already logged in'
      redirect_to :root
    else
      user = User.find_by(username: params[:session][:username])
      if user && user.authenticate(params[:session][:password])
        log_in user
        redirect_to :root      
      else
        flash[:error] = 'Invalid username/password'
        redirect_to :root
      end
    end
  end
    
  def destroy
    log_out
    redirect_to :root
  end
end
