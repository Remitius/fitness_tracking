require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @workout = valid_workout
  end

  test "site header" do
    get new_workout_path
    assert_select 'a[href="/"]', count: 1
  end

  test "link to root path not present in root path's header" do
    get root_path
    assert_select 'a[href="/"]', false
  end

  test "form elements on _workout_form partial" do
    get edit_workout_path(@workout)
    assert_template partial: '_workout_form'
    assert_select "label[for='workout_name']", count: 1
    assert_select "label[for='workout_date']", count: 1
    assert_select "label[for='workout_note']", count: 1
  end

  test 'link back to workouts#show page from workouts#edit' do
    get edit_workout_path(@workout)
    assert_select "a[href='#{workout_path(@workout.id)}']", count: 1
  end

  test "exercise form elements onn _exercise_form partial" do
    get workout_path(@workout)
    assert_template partial: '_exercise_form'    
    assert_select "label[for='exercise_name']", count: 1
    assert_select "label[for='exercise_note']", count: 1
  end

  test "e_set form elements on workouts#show" do
    get workout_path(@workout)
    assert_select "#e-set-fields"
    assert_select "a", "add set", count: 1
  end

  test "exercise edit" do
    exer = valid_exercise(@workout)
    get edit_workout_exercise_path(@workout, exer)
    assert_template partial: '_exercise_form'    
    assert_select "a[href='#{workout_path(@workout.id)}']", count: 1
  end

  test 'presence of _user_form on users#edit and users#new' do
    get new_user_path
    assert_template 'users/_user_form'
    get edit_user_path(valid_user.id)
    assert_template 'users/_user_form'
  end

  test '_user_form elements' do
    get new_user_path
    assert_select "input[type='text']", count: 1
    assert_select "input[type='password']", count: 2
  end

end
