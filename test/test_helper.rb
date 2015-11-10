ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in a-z order
  fixtures :all

  def valid_workout(name: 'name123', date: 1.day.ago, note: nil, save: false)
    w = Workout.new(name: name, date: date, note: note)
    w.save if save
    w
  end

  def valid_exercise(workout, name: 'name123', note: nil, save: false)
    e = Exercise.new(workout: workout, name: name, note: note)
    e.save if save
    e
  end

  def valid_e_set(exercise, pounds: 500.5, reps: nil, save: false)
    es = ESet.new(exercise: exercise, pounds: pounds, reps: reps)
    es.save if save
    es
  end
end
