class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    find_user
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to :root
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      flash.now[:error] = []
      @user.errors.full_messages.each { |e| flash.now[:error] << e }
      render 'new'
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
    if logged_in? && @user.update_attributes(user_params)
      redirect_to @user
    else
      flash.now[:error] = []
      @user.errors.full_messages.each { |e| flash.now[:error] << e }
      render 'edit'
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
