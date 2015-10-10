require 'test_helper'

class ExerciseCreationTest < ActionDispatch::IntegrationTest
  def setup
    @workout = Workout.create(id: 1, name: "sprints", date: "2012-3-20")
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
  end

  test "invalid creation error messages" do
    post_via_redirect workout_exercises_path(@workout), 
                      exercise: { name: "", workout: @workout }
    assert_select "div[class='flash_error']", /Name can't be blank/i

  end
end
