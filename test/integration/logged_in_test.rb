require 'test_helper'

class LoggedInTest < ActionDispatch::IntegrationTest  
  def setup
    @u = valid_user
    @w = valid_workout(user: @u)
    log_in_user(@u)
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

  test 'users#create should fail' do
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

  test 'sessions#create should fail' do
    post_via_redirect login_path, session: { username: @u.username, 
                                password: @u.password }                      
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
