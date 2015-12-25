class UsersController < ApplicationController
  def new
    if logged_in?
      flash[:error] = 'You cannot create an account while logged in'
      redirect_to :root
    else
      @user = User.new
    end
  end

  def show
    unless find_user && logged_in_as_user?(@user)
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    end
  end

  def create
    if logged_in?
      flash[:error] = 'You cannot create an account while logged in'
      redirect_to :root
    else
      @user = User.new(user_params)
      if @user.save
        log_in(@user)
        redirect_to :root
      else
        flash.now[:error] = []
        @user.errors.full_messages.each { |e| flash.now[:error] << e }
        render 'new'
      end
    end
  end
    
  def edit
    find_user
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to :root
    elsif !logged_in_as_user?(@user)
      flash[:error] = "You are not logged in as that user"
      redirect_to :root
    end
  end

  def update
    find_user
    if logged_in_as_user?(@user) && @user.update_attributes(user_params)
      redirect_to @user
    elsif !logged_in_as_user?(@user)
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    else
      flash.now[:error] = []
      @user.errors.full_messages.each { |e| flash.now[:error] << e }
      render 'edit'
    end
  end

  def destroy
    find_user
    if logged_in_as_user?(@user)
      log_out
      @user.destroy
      redirect_to :root
    else
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, 
                                 :password_confirmation)
  end

end
