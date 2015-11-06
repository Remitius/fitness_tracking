class ExercisesController < ApplicationController
  def create
    @exercise = Exercise.new(exercise_params)
    unless @exercise.save
      flash[:error] = []
      @exercise.errors.full_messages.each do |e| 
        flash[:error] << e
      end
    end
    redirect_to workout_url(params[:workout_id])
  end

  def destroy
    Exercise.find(params[:id]).destroy
    redirect_to workout_path(params[:workout_id])
  end

  def edit
    @workout = Workout.find(params[:workout_id])
    @exercise = Exercise.find(params[:id])
  end

  def update
    @exercise = Exercise.find(params[:id])
    if @exercise.update_attributes(exercise_params)
      redirect_to workout_path(params[:workout_id])
    else
      flash[:error] = []
      @exercise.errors.full_messages.each do |e|
        flash[:error] << e
      end
      redirect_to edit_workout_exercise_path(@exercise.workout, @exercise)
    end
  end

  def index
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :note, 
    e_sets_attributes: [:id, :_destroy, :pounds, :reps])
    .merge({workout_id: params[:workout_id]})
  end 
end
