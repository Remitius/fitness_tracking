class WorkoutsController < ApplicationController
  def index
    if params['page'] && Workout.first.exists?
      p = params['page'].to_i * 10
      @workouts = Workout.order(:date)[(p-10)...p]
    else
      @workouts = Workout.order(:date).first(10)
    end
  end

  def new
  end

  def edit
  end

  def show
  end
end
