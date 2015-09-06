class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def new
  end

  def edit
  end

  def show
  end
end
