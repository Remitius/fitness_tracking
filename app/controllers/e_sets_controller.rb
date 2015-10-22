class ESetsController < ApplicationController
  def destroy
    ESet.find(params[:id]).destroy    
    redirect_to workout_path(params[:workout_id])
  end
end
