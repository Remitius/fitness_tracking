require 'test_helper'

class WorkoutExercisesTest < ActionDispatch::IntegrationTest
  def setup
    @w = valid_workout
    log_in_user(@w.user)
  end

  test "valid exercise creation - without e_sets" do
    post_via_redirect workout_exercises_path(@w),
             exercise: { name: 'sprints', note: 'hi' }
    assert_template 'workouts/show'
    assert_select ".exercise_note_and_sets", count: 1
    assert_select ".exercise_name", count: 1
    assert_select "a[href='#{exercises_index_path(name: 'sprints')}']"
  end

  test "invalid exercise creation - without e_sets" do
    post_via_redirect workout_exercises_path(@w), 
              exercise: { name: "" }
    assert_template 'workouts/show'
    assert_select ".exercise_note_and_sets", false
    assert_select ".exercise_name", false
    assert_select "#flash_error", /Name can't be blank/i
  end

  test "valid exercise creation - with e_sets" do
    assert_difference 'ESet.count', 1 do
      post_via_redirect workout_exercises_path(@w),
                        exercise: { name: 'sprints', note: 'hi',
                        e_sets_attributes: 
                        { 0 => {pounds: 22, reps: 10} } }
    end
    assert_template 'workouts/show'
  end

  test "invalid exercise creation - with e_sets" do
    assert_no_difference 'ESet.count' do
      post_via_redirect workout_exercises_path(@w),
                        exercise: { note: 'hi', e_sets_attributes: 
                        { 0 => {pounds: 22, reps: 10} } }
    end
    assert_template 'workouts/show'
  end

  test "valid exercise destruction - without e_sets" do
    e = valid_exercise(@w)
    delete workout_exercise_path(@w, e)
    assert_redirected_to workout_path(@w)
    assert_not Exercise.find_by(id: e.id)
  end

  test "valid exercise destruction - with e_sets" do
    e = valid_exercise(@w)
    3.times { valid_e_set(e) }
    e_sets_ids = e.e_sets.ids

    delete workout_exercise_path(@w, e)
    assert_redirected_to workout_path(@w)
    e_sets_ids.each { |i| assert_not ESet.find_by(id: i) }
  end

  test 'exercises#edit should redirect to workout if invalid id' do
    get edit_workout_exercise_path(@w, 9999)
    assert_redirected_to workout_path(@w)
    follow_redirect!
    assert_select '#flash_error'
  end

  test 'exercises#edit should redirect to root if invalid workout id' do
    get_via_redirect edit_workout_exercise_path(4333, 9999)
    assert_template 'workouts/index'
    assert_select '#flash_error'
  end

  test "e_set destruction" do
    e = valid_exercise(@w)
    s = valid_e_set(e)
    delete workout_exercise_e_set_path(@w, e, s)
    assert_redirected_to workout_path(@w)
    assert_not ESet.find_by(id: s.id)
    assert_select ".exercise_note_and_sets", false, /#{s.reps}/ 
  end

  test "exercise update" do
    e = valid_exercise(@w)
    s = valid_e_set(e)

    put workout_exercise_path(@w, e), 
                     exercise: { note: "heh",
                     e_sets_attributes: {0 => {pounds: 22, reps: 10}} }
    follow_redirect!
    assert_equal "heh", Exercise.find(e.id).note
    assert_equal 2, e.e_sets.count
    assert_template "workouts/show"
    assert_select ".exercise_note_and_sets", /22.0 pounds/
    assert_select ".exercise_note_and_sets", /#{s.pounds}/
  end

end
