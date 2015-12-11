module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user_exercises
    return nil unless current_user
    exercises = []
    current_user.workouts.each do |w|
      w.exercises.each { |e| exercises << e }
    end
    exercises
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_as_user?(user)
    session[:user_id] == user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
