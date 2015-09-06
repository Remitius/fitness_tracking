class WorkoutsController < ApplicationController
  def index
    @workouts = Workouts.all
  end

  def new
  end

  def edit
  end

  def show
  end
end
