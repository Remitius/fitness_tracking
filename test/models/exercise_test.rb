require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @workout = valid_workout(save: true)
    @exercise = valid_exercise(@workout)
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

  test "workout should exist in the database" do
    @exercise.workout = Workout.new(name: "lunges", date: "2009-1-3")
    assert_not @exercise.valid?
  end

  test "exercise should be deleted from the db when its workout is" do
    assert_no_difference 'Exercise.count' do 
      @exercise.save
      @workout.destroy
    end
    assert_not Exercise.find_by(id: @exercise.id)
  end

  test "amount of sets should not be too large" do
    @exercise.save

    10.times { valid_e_set(@exercise, save: true) }
    assert_equal 10, @exercise.e_sets.count

    valid_e_set(@exercise, save: true)
    assert_equal 10, @exercise.e_sets.count
    assert @exercise.valid?
  end

  test "nested e_sets" do
    assert_difference 'ESet.count', 1 do 
      Exercise.create(workout: @workout, name: 'x', e_sets_attributes: 
                                      { 0 => {pounds: 22, reps: 10} })
    end
  end

end
