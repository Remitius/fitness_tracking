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
    @exercise_names = []
    Exercise.all.each do |e| 
      n = e.name.downcase
      @exercise_names << n unless @exercise_names.include?(n)
    end
    @exercise_names.sort!

    if params[:name]
      exercises= Exercise.all.select{|e| e.name.downcase == params[:name]}
      if exercises.present?
        @data = {}
        @data[:first_instance], @data[:last_instance] =
               find_first_and_last_instances(exercises)
        @data[:number_of_instances] = ActionController::Base.helpers
        .pluralize(exercises.count, "total occurrence")
      end
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :note, 
    e_sets_attributes: [:id, :_destroy, :pounds, :reps])
    .merge({workout_id: params[:workout_id]})
  end 

  def find_first_and_last_instances(exercises)
    first = latest = exercises[0]
    exercises.drop(1).each do |e|
      latest = e if e.workout.date > latest.workout.date
      first = e if e.workout.date < first.workout.date
    end

    a = ["first occurrence: #{first.workout.date}"]
    a << "latest occurrence: #{latest.workout.date}"
  end

end
