require 'test_helper'

class WorkoutCreationTest < ActionDispatch::IntegrationTest
  test "valid creation" do
    get create_workout_path

    assert_difference 'Workout.count', 1 do 
      post_via_redirect workouts_path, workout: { name: 'Max Lower', 
                                                  date: 1.days.ago }
      after_count = Workout.count
    end

    assert_template "/"
  end

  test "invalid creation" do
    get create_workout_path

    assert_no_difference 'Workout.count' do 
      post workouts_path, workout: { date: 'hi' }
      after_count = Workout.count
    end

    assert_template "workouts/new"
  end
end
