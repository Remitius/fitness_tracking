require 'test_helper'

class WorkoutExerciseRelationTest < ActionDispatch::IntegrationTest
  def setup
    @workout = valid_workout(save: true)
  end

  test "valid exercise creation - without e_sets" do
    post_via_redirect workout_exercises_path(@workout),
             exercise: { name: 'sprints', note: 'hi' }
    assert_template 'workouts/show'
    assert_select "ul[class='exercise_note_and_sets']", count: 1
    assert_select "h4[class='exercise_name']", count: 1
  end

  test "invalid exercise creation - without e_sets" do
    post_via_redirect workout_exercises_path(@workout), 
              exercise: { name: "" }
    assert_template 'workouts/show'
    assert_select "ul[class='exercise_note_and_sets']", count: 0
    assert_select "h4[class='exercise_name']", count: 0
    assert_select "div[class='flash_error']", /Name can't be blank/i
  end

  test "valid exercise creation - with e_sets" do
    assert_difference 'ESet.count', 1 do
      post_via_redirect workout_exercises_path(@workout),
                        exercise: { name: 'sprints', note: 'hi',
                        e_sets_attributes: 
                        { 0 => {pounds: 22, reps: 10} } }
    end
    assert_template 'workouts/show'
  end

  test "invalid exercise creation - with e_sets" do
    assert_no_difference 'ESet.count' do
      post_via_redirect workout_exercises_path(@workout),
                        exercise: { note: 'hi', e_sets_attributes: 
                        { 0 => {pounds: 22, reps: 10} } }
    end
    assert_template 'workouts/show'
  end

  test "valid exercise destruction - without e_sets" do
    e = valid_exercise(@workout, save: true)
    exer_id = e.id
    delete workout_exercise_path(@workout.id, exer_id)
    assert_redirected_to workout_path(@workout.id)
    assert_not Exercise.find_by(id: exer_id)
  end

  test "valid exercise destruction - with e_sets" do
    e = valid_exercise(@workout, save: true)
    3.times { valid_e_set(e, save: true) }
    e_sets_ids = e.e_sets.ids

    delete workout_exercise_path(@workout.id, e.id)
    e_sets_ids.each { |i| assert_not ESet.find_by(id: i) }
    
  end

end
