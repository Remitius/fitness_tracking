class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user      
    else
      flash.now[:error] = 'Invalid username/password'
      render 'new'
    end
  end
    
  def destroy
    log_out
    redirect_to :root
  end
end
