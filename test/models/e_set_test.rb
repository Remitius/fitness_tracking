require 'test_helper'

class ESetTest < ActiveSupport::TestCase
  def setup
    @workout = valid_workout(save: true)
    @exercise = valid_exercise(@workout, save: true)
    @set = valid_e_set(@exercise)
  end

  test "should be valid" do
    assert @set.valid?, @set.errors.inspect
  end

  test "either sets or reps should be required" do
    @set.reps = nil
    @set.pounds = nil
    assert_not @set.valid?, @set.errors.inspect

    @set.reps = 2
    assert @set.valid?, @set.errors.inspect
    @set.reps = nil

    @set.pounds = 50
    assert @set.valid?, @set.errors.inspect
  end

  test "pounds should not be too large" do
    @set.pounds = 5000
    assert_not @set.valid?, @set.errors.inspect
  end

  test "pounds should be positive or zero" do
    @set.pounds = -0.1
    assert_not @set.valid?, @set.errors.inspect
  end

  test "reps should be positive or zero" do
    @set.reps = -0.1
    assert_not @set.valid?, @set.errors.inspect
  end

  test "reps should not be too large" do
    @set.reps = 1000
    assert_not @set.valid?, @set.errors.inspect
  end

  test "set should be deleted from the db when its exercise is" do
    assert_no_difference "ESet.count" do
      @set.save
      @set.exercise.destroy
    end
    assert_not ESet.find_by(id: @set.id)
  end

end
