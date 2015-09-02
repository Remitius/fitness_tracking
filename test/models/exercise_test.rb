require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @exercise = Exercise.new(name: "Lunges", sets: 3, repetitions: 10, 
                                            seconds: 60.2, note: "PR")
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

  test "number of sets should not be too large" do
    @exercise.sets = 1000
    assert_not @exercise.valid?
  end

  test "number of repetitions should not be too large" do
    @exercise.repetitions = 1000
    assert_not @exercise.valid?
  end

  test "seconds should not be too large" do
    @exercise.seconds = 100000
    assert_not @exercise.valid?
  end

  test "note should not be too long" do
    @exercise.note = 'a' * 100
    assert_not @exercise.valid?
  end

  test "sets, repetitions, seconds, and note should be optional" do
    assert @exercise.valid?
  end

end
