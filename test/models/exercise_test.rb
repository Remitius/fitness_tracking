require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @workout = Workout.create(id: 1, name: "sprints", date: "2012-3-20")
    @exercise = Exercise.new(name: "bench press", note: "PR", 
                             workout: @workout)
  end

  test "should be valid" do
    assert @exercise.valid?
  end

  test "name should not be too long" do
    @exercise.name = 'a' * 41
    assert_not @exercise.valid?
  end

  test "name should not be empty" do
    @exercise.name = ''
    assert_not @exercise.valid?
  end

  test "note should not be too long" do
    @exercise.note = 'a' * 100
    assert_not @exercise.valid?
  end

  test "all attributes except name and workout should be optional" do
    @exercise = Exercise.new(name: "sprints", workout: @workout)
    assert @exercise.valid?
  end

  test "workout should exist" do
    @exercise.workout = nil
    assert_not @exercise.valid?
  end

  test "workout should exist in the database" do
    @exercise.workout = Workout.new(name: "lunges", date: "2009-1-3")
    assert_not @exercise.valid?
  end

  test "exercise should be deleted from the db when its workout is" do
    @exercise.save
    @exercise.workout.destroy
    assert_not Exercise.find_by(id: @exercise.id)
  end

end
