require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = valid_user
  end

  test 'login with valid information' do
    log_in_user(@user)
    assert_template 'workouts/index'
    assert_select "a[href=?]", logout_path
  end

  test "login with invalid information" do
    post_via_redirect login_path, session: { username: 'h', password: 'n' }
    assert_template 'static_pages/home'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'logging out' do
    log_in_user(@user)
    delete logout_path 
    assert_redirected_to :root
  end

  test 'header links based on whether or not a session exists' do
    get root_path
    assert_select "a[href=?]", exercises_index_path, false
    assert_select "a[href=?]", new_user_path

    log_in_user(@user)

    assert_select "a[href=?]", exercises_index_path
    assert_select "a[href=?]", new_user_path, false
  end

  test 'successful retrieval of user edit page' do
    log_in_user(@user)
    get edit_user_path(@user)
    assert_response :success
    assert_template 'users/edit'
  end

  test 'valid user update' do
    log_in_user(@user)
    new_username = 'new_name'
    id = @user.id
    put user_path(@user), user: { username: new_username, password: 
                              'jjj111', password_confirmation: 'jjj111' }
    assert_equal new_username, User.find(id).username
  end

  test 'invalid user update' do
    log_in_user(@user)
    old_username = @user.username
    id = @user.id
    put user_path(@user), user: { username: '2' }
    assert_equal old_username, User.find(id).username
  end

  test 'users#show link to users#edit/destroy only if logged in as user' do
    get user_path(@user)
    assert_select "a[href='#{edit_user_path(@user)}']", false
    assert_select "a[href='#{user_path(@user)}']", false    

    log_in_user(@user)
    get user_path(@user)
    assert_select "a[href='#{edit_user_path(@user)}']"
    assert_select "a[href='#{user_path(@user)}']"
  end

  test 'users#destroy' do
    log_in_user(@user)
    delete user_path(@user)
    assert_not User.find_by(id: @user.id)
    assert_redirected_to :root
  end

end
