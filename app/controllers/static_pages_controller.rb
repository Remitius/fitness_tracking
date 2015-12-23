class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_action :verify_user

  def calculators
  end

  def calculate
    find_wilks if params[:wilks]
    find_one_rep_max if params[:one_rep_max]
    redirect_to calculators_path
  end

  private

  def verify_user
    unless logged_in?
      flash[:error] = "You are not logged in"
      redirect_to :root
    end
  end

  def find_one_rep_max
    weight = params[:one_rep_max][:weight].to_f
    reps = params[:one_rep_max][:reps].to_i
    max = one_rep_max_brzycki(weight, reps)
    flash[:one_rep_max] = "#{weight} x #{reps} reps = #{max.round(2)}
                           (units irrelevant)"
  end

  def find_wilks
    wilks = wilks_score(params[:wilks][:bodyweight].to_f,
      params[:wilks][:total].to_f, params[:wilks][:units].to_sym, 
      params[:wilks][:gender].to_sym)
    flash[:wilks] = "#{params[:wilks][:total]}@" +
     "#{params[:wilks][:bodyweight]} #{params[:wilks][:units]}
     = #{wilks.round(2)} wilks"
  end
end
 