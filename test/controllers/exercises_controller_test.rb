require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  def setup
    @workout = Workout.create(id: 1, name: "sprints", date: "2012-3-20")
    @exercise = Exercise.create(name: "bench press", note: "PR",
                                workout: @workout)
  end

  test "valid update should properly alter the record" do
    
  end

  test "invalid update should not alter the record" do
    
  end

  test "destroy should remove the record" do
    #assert workout preserved
  end
end
