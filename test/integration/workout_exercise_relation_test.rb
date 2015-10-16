require 'test_helper'

class WorkoutExerciseRelationTest < ActionDispatch::IntegrationTest
  def setup
    @workout = valid_workout(save: true)
  end

  test "valid creation" do
    post_via_redirect workout_exercises_path(@workout), 
                      exercise: { name: "sprints", workout: @workout }
    assert_template 'workouts/show'
    assert_select "ul[class='exercise']", count: 1
    assert_select "h3[class='exercise_name']", count: 1
  end

  test "invalid creation" do
    post_via_redirect workout_exercises_path(@workout), 
                      exercise: { name: "", workout: @workout }
    assert_template 'workouts/show'
    assert_select "ul[class='exercise']", count: 0
    assert_select "h3[class='exercise_name']", count: 0
    assert_select "div[class='flash_error']", /Name can't be blank/i
  end

  test "valid destruction" do
    exercise = valid_exercise(@workout, save: true)
    id = exercise.id
    delete workout_exercise_path(@workout.id, id)
    assert_redirected_to workout_path(@workout.id)
    assert_not Exercise.find_by(id: id)
  end
end
