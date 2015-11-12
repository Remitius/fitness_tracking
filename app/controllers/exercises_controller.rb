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
      exercises = Exercise.all.select{|e| e.name.downcase == params[:name]}
      @sets = ESet.all.select{|s| s.exercise.name.downcase == params[:name]}
      @sets.sort! {|a,b| b.exercise.workout.date <=> a.exercise.workout.date}
      gather_exercise_data(exercises) if exercises.present?
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :note, 
    e_sets_attributes: [:id, :_destroy, :pounds, :reps])
    .merge({workout_id: params[:workout_id]})
  end 

  def gather_exercise_data(exercises)
    @data = {}

    @data[:number_of_instances] = exercises.count

    @data[:first_instance], @data[:last_instance] =
           find_first_and_last_instances(exercises)

    @data[:lightest_set], @data[:heaviest_set] = 
            find_lightest_and_heaviest_sets(exercises)
  end

  def find_lightest_and_heaviest_sets(exercises)
    sets = @sets.select { |s| s.pounds }
    return nil if sets.empty?

    lightest = heaviest = sets[0]
    sets.drop(1).each do |s|
      lightest = s if s.pounds < lightest.pounds
      heaviest = s if s.pounds > heaviest.pounds
    end

    lightest_info = { pounds: lightest.pounds, date: lightest.exercise.workout.date }
    lightest_info[:reps] = lightest.reps if lightest.reps
    lightest_info[:workout_id] = lightest.exercise.workout
    heaviest_info = { pounds: heaviest.pounds, date: heaviest.exercise.workout.date }
    heaviest_info[:reps] = heaviest.reps if heaviest.reps
    heaviest_info[:workout_id] = heaviest.exercise.workout

    [lightest_info, heaviest_info]
  end

  def find_first_and_last_instances(exercises)
    first = latest = exercises[0]
    exercises.drop(1).each do |e|
      latest = e if e.workout.date > latest.workout.date
      first = e if e.workout.date < first.workout.date
    end
    a = []
    a[0] = {date: first.workout.date, workout_id: first.workout_id}
    a << {date: latest.workout.date, workout_id: latest.workout_id}
 end

end
