require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  def setup
    @workout = Workout.new(name: "Lower Body", note: "great", 
                                            date: "2015-3-9")
  end

  test "should be valid" do
    assert @workout.valid?
  end

  test "name should be present" do
    @workout.name = ''
    assert_not @workout.valid? 
  end

  test "name should not be too long" do
    @workout.name = 'a' * 36
    assert_not @workout.valid?     
  end

  test "note should be optional" do
    @workout.note = nil
    assert @workout.valid?
  end

end
