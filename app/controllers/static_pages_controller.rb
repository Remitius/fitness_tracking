class StaticPagesController < ApplicationController
  def calculators
    unless logged_in?
      flash[:error] = "You are not logged in"
      redirect_to :root
    end
  end
end
 