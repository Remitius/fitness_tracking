class WorkoutsController < ApplicationController
  before_action :verify_user, except: [:index]

  def index
    if current_user.nil?
      params[:disable_header] = true
      render 'static_pages/home'
    elsif params['page'] && params['page'].to_i > 0
      p = params['page'].to_i * 10
      @workouts = current_user.workouts.order('date DESC')[(p-10)...p]
      params[:next_page_valid] = true if current_user.workouts.count > p
    else
      @workouts = current_user.workouts.order('date DESC').first(10)
      params[:next_page_valid] = true if current_user.workouts.count > 10
    end
  end

  def new
    @workout = Workout.new
  end

  def create
    @workout = Workout.new(workout_params)
    if @workout.save
      redirect_to @workout
    else
      fill_flash_now_with_workout_errors
      render 'new'
    end
  end

  def edit
    find_workout
    unless @workout
      flash[:error] = "Workout not found"
      redirect_to :root
    end
  end

  def show
    find_workout
    unless @workout
      flash[:error] = "Workout not found"
      redirect_to :root
    end
  end

  def update
    find_workout
    if @workout.update_attributes(workout_params)
      render 'show'
    else
      @workout.reload
      fill_flash_now_with_workout_errors
      render 'edit'
    end
  end

  def destroy
    Workout.find(params[:id]).destroy
    redirect_to :root
  end
  
  private

  def verify_user
    if current_user.nil?
      flash[:error] = 'You are not logged in'
      redirect_to :root
    elsif find_workout && current_user.id != find_workout.user_id
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    end
  end

  def workout_params
    params.require(:workout).permit(:name, :date, :note, :user_id)
  end

  def find_workout
    @workout = Workout.find_by(id: params[:id])
  end

  def fill_flash_now_with_workout_errors
    flash.now[:error] = []
    @workout.errors.full_messages.each do |e|
      flash.now[:error] << e
    end
  end

end
