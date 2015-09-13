class WorkoutsController < ApplicationController
  def index
    if params['page'] && Workout.any?
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
    @workout = Workout.new(user_params)
    if @workout.save
      redirect_to :root
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    begin
    @workout = Workout.find(params[:id])
    rescue ActiveRecord::RecordNotFound => rnf
      redirect_to :root
      flash[:error] = "Workout not found"
    end
  end

  def update
    @workout = Workout.find(params[:id])
    unless @workout.update_attributes(user_params)
      flash[:error] = "Workout update was unsuccessful"
    end
    redirect_to @workout

  end

  def user_params
    params.require(:workout).permit(:name, :date)
  end
end
