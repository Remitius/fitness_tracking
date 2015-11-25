ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in a-z order
  fixtures :all

  def valid_workout(name: 'name1', date: 1.day.ago, note: nil, save: true)
    w = Workout.new(name: name, date: date, note: note)
    w.save if save
    w
  end

  def valid_exercise(workout, name: 'name1', note: nil, save: true)
    e = Exercise.new(workout: workout, name: name, note: note)
    e.save if save
    e
  end

  def valid_e_set(exercise, pounds: 123.4, reps: nil, save: true)
    es = ESet.new(exercise: exercise, pounds: pounds, reps: reps)
    es.save if save
    es
  end

  def valid_user(username: 'username1', password: 'abcd1234', save: true)
    u = User.new(username: username, password: password,
                 password_confirmation: password)
    u.save if save
    u
  end
end
