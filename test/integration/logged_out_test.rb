require 'test_helper'

class LoggedOutTest < ActionDispatch::IntegrationTest
  def setup
    @w = valid_workout
    @e = valid_exercise(@w)
  end
  
  test 'root should redirect to static_pages#home' do
    get root_path
    assert_template 'static_pages/home'
  end

  test 'workouts#show redirects to root' do
    get workout_path(@w)
    assert_redirected_to :root
    assert flash.present?
  end

  test 'workouts#edit redirects to root' do
    get edit_workout_path(@w)
    assert_redirected_to :root
    assert flash.present?
  end

  test 'exercises#edit redirects to root' do
    get edit_workout_exercise_path(@w, @e)
    assert_redirected_to :root
    assert flash.present?
  end

  test 'workouts#new redirects to root' do
    get new_workout_path
    assert_redirected_to :root
    assert flash.present?
  end

  test 'exercises#index redirects to root' do
    get exercises_index_path
    assert_redirected_to :root
    assert flash.present?
  end

  test 'users#edit redirects to root' do
    get edit_user_path(@w.user)
    assert_redirected_to :root
    assert flash.present?
  end

  test 'exercises#create fails' do
    assert_no_difference 'Exercise.count' do
      post_via_redirect workout_exercises_path(@w),
               exercise: { name: 'sprints', note: 'hi' }
    end
  end

  test 'exercises#update fails' do
    orig_name = @e.name
    put workout_exercise_path(@w, @e), exercise: { name: 'hello' }
    assert_equal orig_name, @e.reload.name
  end

  test 'exercises#destroy fails' do
    assert_no_difference 'Exercise.count' do
      delete workout_exercise_path(@w, @e)
    end
  end

  test 'workouts#create fails' do
    assert_no_difference 'Workout.count' do
      post workouts_path, workout: valid_workout(save: false).attributes
    end
  end

  test 'workouts#update fails' do
    orig_name = @e.name
    put workout_exercise_path(@w, @e), exercise: { name: 'hello' }
    assert_equal orig_name, @e.reload.name
  end

  test 'workouts#destroy fails' do
    assert_no_difference 'Workout.count' do
      delete workout_path(@w)
    end
  end

  test 'users#update fails' do
    user = @w.user
    old_username = user.username
    put user_path user, user: { id: user.id, username: 'john553', 
                   password: 'jjj111', password_confirmation: 'jjj111' }
    assert_equal old_username, user.reload.username
  end

end
