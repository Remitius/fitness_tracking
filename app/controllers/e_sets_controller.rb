class ESetsController < ApplicationController
  def destroy
    if current_user.nil?
      flash[:error] = 'You are not logged in'
      redirect_to :root
    elsif find_e_set && current_user.id != find_e_set.exercise.workout.user_id
      flash[:error] = 'You are not logged in as that user'
      redirect_to :root
    end
    ESet.find(params[:id]).destroy    
    redirect_to workout_path(params[:workout_id])
  end

  def find_e_set
    @exercise = ESet.find_by(params[:id])
  end

end
