class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_action :verify_user

  def calculators
  end

  def calculate
    wilks_message = calculate_wilks if params[:wilks]
    redirect_to calculators_path
  end

  private

  def verify_user
    unless logged_in?
      flash[:error] = "You are not logged in"
      redirect_to :root
    end
  end

  def calculate_wilks
    wilks = wilks_score(params[:wilks][:bodyweight].to_f,
      params[:wilks][:total].to_f, params[:wilks][:units].to_sym, 
      params[:wilks][:gender].to_sym)
    flash[:wilks] = "#{params[:wilks][:total]}@" +
     "#{params[:wilks][:bodyweight]} #{params[:wilks][:units]}
     = #{wilks.round(2)} wilks"
  end
end
 