class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_action :verify_user

  def calculators
  end

  def calculate
    find_bmi if params[:bmi]
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

  def find_bmi
    w = params[:bmi][:bodyweight].to_f
    h = params[:bmi][:height].to_f
    u = params[:bmi][:units].to_sym
    bmi_value = bmi(w, h, u)
    flash[:bmi] = bmi_message(bmi_value, w, h, u)
  end

  def bmi_message(bmi_value, weight, height, units)
    if units == :imperial
      msg = "BMI of #{bmi_value.round(2)} at #{weight} lb/#{height} in. = "
    elsif units == :metric
      msg = "BMI of #{bmi_value.round(2)} at #{weight} kg & #{height} cm = "
    end

    msg += case
    when bmi_value < 18.5
      "underweight"
    when bmi_value < 25
      "normal range"
    when bmi_value < 30
      "overweight"
    else
      "obese"
    end
  end

  def find_wilks
    wilks = wilks_score(params[:wilks][:bodyweight].to_f,
      params[:wilks][:total].to_f, params[:wilks][:units].to_sym, 
      params[:wilks][:gender].to_sym)
    flash[:wilks] = "#{params[:wilks][:total]}@" +
     "#{params[:wilks][:bodyweight]} #{params[:wilks][:units]}
     = #{wilks.round(2)} wilks"
  end

  def find_one_rep_max
    weight = params[:one_rep_max][:weight].to_f
    reps = params[:one_rep_max][:reps].to_i
    max = one_rep_max_brzycki(weight, reps)
    flash[:one_rep_max] = "#{weight} x #{reps} reps = #{max.round(2)}
                           (units irrelevant)"
  end

end
 