class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    find_user
    redirect_to_root_if_user_is_nil
  end

  def show
    find_user
    redirect_to_root_if_user_is_nil
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      flash.now[:error] = []
      @user.errors.full_messages.each do |e|
        flash.now[:error] << e
      end
      render 'new'
    end
  end
    
  def update
    find_user
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      flash.now[:error] = []
      @user.errors.full_messages.each do |e|
        flash.now[:error] << e
      end
      render 'edit'
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def redirect_to_root_if_user_is_nil
    unless @user
      flash[:error] = "User not found"
      redirect_to :root
    end
  end
  def user_params
    params.require(:user).permit(:username, :password, 
                                 :password_confirmation)
  end

end
