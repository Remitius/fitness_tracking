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
      redirect_to :root
    else
      render 'new'
    end
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
    old_attributes = @workout.attributes
    unless @workout.update_attributes(workout_params)
      @workout.name = old_attributes['name']
      @workout.date = old_attributes['date']
      @workout.note = old_attributes['note']
    end
    render 'show'
  end

  def destroy
    Workout.find(params[:id]).destroy
    redirect_to :root
  end
  
  def workout_params
    params.require(:workout).permit(:name, :date, :note)
  end

end
