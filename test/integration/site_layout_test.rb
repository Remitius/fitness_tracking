require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @w = valid_workout
    log_in_user(@w.user)
  end

  test "sitewide header" do
    get new_workout_path
    assert_select 'a[href="/"]', count: 1
  end

  test "header links shouldn't exist if they are the current page" do
    get exercises_index_path
    assert_select "a[href='#{exercises_index_path}']", false
    get_via_redirect root_path
    assert_select "a[href='#{exercises_index_path}']"
  end

  test "form elements on _workout_form partial" do
    get edit_workout_path(@w)
    assert_template partial: '_workout_form'
    assert_select "label[for='workout_name']", count: 1
    assert_select "label[for='workout_date']", count: 1
  end

  test 'link back to workouts#show page from workouts#edit' do
    get edit_workout_path(@w)
    assert_select "a[href='#{workout_path(@w)}']", count: 1
  end

  test "exercise form elements onn _exercise_form partial" do
    get workout_path(@w)
    assert_template partial: '_exercise_form'    
    assert_select "label[for='exercise_name']", count: 1
  end

  test "e_set form elements on workouts#show" do
    get workout_path(@w)
    assert_select "#e-set-fields"
    assert_select "a", "add set", count: 1
  end

  test "exercise edit" do
    exer = valid_exercise(@w)
    get edit_workout_exercise_path(@w, exer)
    assert_template partial: '_exercise_form'    
    assert_select "a[href='#{workout_path(@w)}']", count: 1
  end

  test 'presence of _user_form on users#edit and users#new' do
    delete logout_path
    get new_user_path
    assert_template 'users/_user_form'
    u = valid_user
    log_in_user(u)
    get edit_user_path(u)
    assert_template 'users/_user_form'
  end

  test '_user_form elements' do
    delete logout_path
    get new_user_path
    assert_select "input[type='text']", count: 1
    assert_select "input[type='password']", count: 2
  end

end
