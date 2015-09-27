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

  def show
    begin
    @workout = Workout.find(params[:id])
    rescue ActiveRecord::RecordNotFound => rnf
      flash[:error] = "Workout not found"
      redirect_to :root
    end
  end

  def update
    @workout = Workout.find(params[:id])
    old_attr = @workout.attributes
    unless @workout.update_attributes(workout_params)
      @workout.name = old_attr['name']
      @workout.date = old_attr['date']
      @workout.note = old_attr['note']
      flash.now[:error] = []
      @workout.errors.full_messages.each do |e|
        flash.now[:error] << e
      end
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
