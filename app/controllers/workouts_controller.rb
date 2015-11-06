class WorkoutsController < ApplicationController
  def index
    if params['page'] && params['page'].to_i > 0
      p = params['page'].to_i * 10
      @workouts = Workout.order('date DESC')[(p-10)...p]
    else
      @workouts = Workout.order('date DESC').first(10)
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
      flash.now[:error] = []
      @workout.errors.full_messages.each do |e|
        flash.now[:error] << e
      end
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
      flash.now[:error] = []
      @workout.errors.full_messages.each do |e|
        flash.now[:error] << e
      end
      render 'edit'
    end
  end

  def destroy
    Workout.find(params[:id]).destroy
    redirect_to :root
  end
  
  private

  def workout_params
    params.require(:workout).permit(:name, :date, :note)
  end

  def find_workout
    @workout = Workout.find_by(id: params[:id])
  end

end
