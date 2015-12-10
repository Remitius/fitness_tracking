class ExercisesController < ApplicationController
  before_action :verify_user, except: [:index]

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
    find_exercise.destroy
    redirect_to workout_path(params[:workout_id])
  end

  def edit
    @workout = Workout.find_by(id: params[:workout_id])
    find_exercise
    if @workout.nil?
      flash[:error] = "Workout not found"
      redirect_to :root
    elsif @exercise.nil?
      flash[:error] = "Exercise not found"
      redirect_to workout_path(params[:workout_id])
    end
  end

  def update
    find_exercise  
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
    if !logged_in?
      flash[:error] = 'You are not logged in'
      redirect_to :root
    else
      @current_user_exercises = current_user_exercises
      @exercise_names = gather_exercise_names(@current_user_exercises)

      exercises = current_user_exercises.select{|e| e.name.downcase == params[:name]}
      if exercises.present?
        @exercise_data = gather_exercise_data(exercises)
      end
    end
  end

  private

  def verify_user
    if current_user.nil?
      flash[:error] = 'You are not logged in'
      redirect_to :root
    elsif find_exercise && current_user.id != find_exercise.workout.user_id
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    end
  end

  def find_exercise
    @exercise = Exercise.find_by(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :note, 
    e_sets_attributes: [:id, :_destroy, :pounds, :reps])
    .merge({ workout_id: params[:workout_id] })
  end 

  def gather_exercise_names(exercises)
    names = []
    exercises.each do |e| 
      n = e.name.downcase
      names << n unless names.include?(n)
    end
    names.sort!
  end

  def gather_exercise_data(exercises)
    sets = ESet.all.select{|s| s.exercise.name.downcase == exercises[0].name}
    data = {}

    data[:number_of_instances] = exercises.count
    data[:first_instance], data[:last_instance] = 
        find_first_and_last_instances(exercises)
    data[:lightest_set], data[:heaviest_set] = 
        find_lightest_and_heaviest_sets(sets)
    data[:formatted_sets] = get_formatted_sets(sets)
    data
  end

  def get_formatted_sets(_sets)
    sets = _sets.sort {|a,b| b.exercise.workout.date <=> a.exercise.workout.date}
    sets = get_sets_within_start_date(sets)
    sets = get_heaviest_daily_sets(sets) if !params[:view] || params[:view] == 'line'

    sets.map do |s|
      { pounds: s.pounds, reps: s.reps, workout_id: s.exercise.workout.id,
        date: s.exercise.workout.date.to_s }
    end
  end

  def get_heaviest_daily_sets(_sets_sorted_by_date)
    sets = _sets_sorted_by_date.select { |s| s[:pounds] }

    current = 0
    while (current < sets.length-1)
      if sets[current].exercise.workout.date == sets[current+1].exercise.workout.date
        if (sets[current].pounds < sets[current+1].pounds)
          sets.delete_at(current)
        else
          sets.delete_at(current+1)
        end
      else
        current += 1
      end
    end
    sets
  end

  def get_sets_within_start_date(sets)
    return sets unless params[:start_date].present?
    start_date = params[:start_date].to_i.months.ago
    sets.select { |s| s.exercise.workout.date >= start_date }
  end

  def find_lightest_and_heaviest_sets(_sets)
    sets = _sets.select { |s| s.pounds }
    return nil if sets.empty?

    lightest = heaviest = sets[0]
    sets.drop(1).each do |s|
      lightest = s if s.pounds < lightest.pounds
      heaviest = s if s.pounds > heaviest.pounds
    end

    lightest_info = {pounds: lightest.pounds, date: lightest.exercise.workout.date}
    lightest_info[:reps] = lightest.reps
    lightest_info[:workout_id] = lightest.exercise.workout
    heaviest_info = {pounds: heaviest.pounds, date: heaviest.exercise.workout.date}
    heaviest_info[:reps] = heaviest.reps
    heaviest_info[:workout_id] = heaviest.exercise.workout

    [lightest_info, heaviest_info]
  end

  def find_first_and_last_instances(exercises)
    first = latest = exercises[0]
    exercises.drop(1).each do |e|
      latest = e if e.workout.date > latest.workout.date
      first = e if e.workout.date < first.workout.date
    end
    return [{date: first.workout.date, workout_id: first.workout_id}, 
            {date: latest.workout.date, workout_id: latest.workout_id}]
  end

end
