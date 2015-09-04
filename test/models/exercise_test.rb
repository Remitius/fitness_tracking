require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @exercise = Exercise.new(name: "bench press", sets: 3, repetitions: 10, 
                             seconds: 60.2, note: "PR", workout_id: 1)
    w = Workout.create(id: 1, name: "sprints", date: "2012-3-20")
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

  test "upon saving, name should be downcase" do
    @exercise.name = "LUNGES"
    @exercise.save
    assert @exercise.name = "lunges"
  end

  test "number of sets should not be too large" do
    @exercise.sets = 1000
    assert_not @exercise.valid?
  end

  test "number of sets should be positive" do
    @exercise.sets = -1
    assert_not @exercise.valid?
  end

  test "number of repetitions should not be too large" do
    @exercise.repetitions = 1000
    assert_not @exercise.valid?
  end

  test "number of repetitions should be positive" do
    @exercise.repetitions = -1
    assert_not @exercise.valid?
  end

  test "seconds should not be too large" do
    @exercise.seconds = 100000
    assert_not @exercise.valid?
  end

  test "seconds should be positive" do
    @exercise.seconds = -1
    assert_not @exercise.valid?
  end

  test "note should not be too long" do
    @exercise.note = 'a' * 100
    assert_not @exercise.valid?
  end

  test "sets, repetitions, seconds, and note should be optional" do
    @exercise = Exercise.new(name: "sprints", workout_id: 1)
    assert @exercise.valid?
  end

  test "workout id should exist" do
    @exercise.workout_id = nil
    assert_not @exercise.valid?
  end
  test "workout id should correspond to an existing workout record" do
    @exercise.workout_id = 90
    assert_not @exercise.valid?
  end

end
