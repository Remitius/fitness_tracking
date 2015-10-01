class ExercisesController < ApplicationController
  def create
    @exercise = Exercise.new(exercise_params)
    unless @exercise.save
      flash[:error] = []
      @exercise.errors.full_messages.each do |e| 
        flash[:error] << e
      end
    end
    redirect_to workout_url(params['workout_id'])
  end

  def update
  end

  def destroy
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :reps, :note, 
     :seconds, :pounds).merge({workout_id: params[:workout_id]})
  end 
end
