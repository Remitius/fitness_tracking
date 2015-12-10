require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  def setup
    @workout = Workout.new(name: "Lower Body", note: "great", 
                           date: "2015-3-9", user: valid_user)
  end

  test "should be valid" do
    assert @workout.valid?
  end

  test "name should be present" do
    @workout.name = ''
    assert_not @workout.valid? 
  end

  test "name shouldn't be too long" do
    @workout.name = 'a' * 36
    assert_not @workout.valid?     
  end

  test "note should be optional" do
    @workout.note = nil
    assert @workout.valid?
  end

  test "note shouldn't be too long" do
    @workout.note = 'a' * 301
    assert_not @workout.valid?
  end

  test "date should be present" do
    @workout.date = nil
    assert_not @workout.valid?
  end

  test "date shouldn't be too far in the past" do
    @workout.date = '1999-12-31'
    assert_not @workout.valid?    
  end

  test "date shouldn't be too far ahead" do
    @workout.date = 2.years.from_now + 1.day
    assert_not @workout.valid?
  end

  test "amount of exercises shouldn't be too large" do
    @workout.save

    12.times { valid_exercise(@workout) }
    assert_equal 12, @workout.exercises.count

    valid_exercise(@workout)
    assert_equal 12, @workout.exercises.count
    assert @workout.valid?
  end  

  test "exercise update won't succeed if exercise capacity is reached" do
    @workout.save

    e = valid_exercise(@workout)
    11.times { valid_exercise(@workout) }
    e.name = 'hi'
    assert e.valid?
  end

  test "workout should be deleted from DB when its user is" do
    u = valid_user
    w = valid_workout(user: u)
    u.destroy
    assert_not Workout.find_by(id: w.id)
  end

end
