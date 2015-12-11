require 'test_helper'

class LoggedInTest < ActionDispatch::IntegrationTest  
  def setup
    @w = valid_workout
    log_in_user(@w.user)
  end

  test 'root should redirect to workouts index' do
    get root_path
    assert_template 'workouts/index'
  end

  test 'users#new redirects to workouts index' do
    get new_user_path
    assert_redirected_to :root
    assert flash.present?
  end

  test 'users#create should fail if logged in' do
    assert_no_difference 'User.count' do 
      post users_path, user: { username: 'user12', password: 'hah1234',
                               password_confirmation: 'hah1234' }
    end
    assert_redirected_to :root
    assert flash.present?
  end

  test 'sessions#new redirects to root' do
    get login_path
    assert_redirected_to :root
    assert flash.present?
  end

  test 'sessions#create should fail if logged in' do
    post_via_redirect login_path, session: { username: @w.user.username, 
                                password: @w.user.password }                      
    assert_template 'workouts/index'
    assert flash.present?
  end

  test "exercises#index should only show exercises belonging to the user" do
    exer_name = 'flies'
    valid_e_set(valid_exercise(valid_workout, name: exer_name))
    get exercises_index_path, name: exer_name
    assert_template 'exercises/index'
    assert_select '#exercise-info', false
  end

end
