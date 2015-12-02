require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = valid_user
  end

  test 'login with valid information' do
    log_in_user(@user)
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { username: 'h', password: 'n' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'logging out' do
    log_in_user(@user)
    assert_select "a[href=?]", login_path, false
    delete logout_path 
    assert_redirected_to :root
    follow_redirect!
    assert_select "a[href=?]", login_path
  end

  test 'header links based on whether or not a session exists' do
    get root_path
    assert_select "a[href=?]", exercises_index_path, false
    assert_select "a[href=?]", new_user_path

    log_in_user(@user)

    assert_select "a[href=?]", exercises_index_path
    assert_select "a[href=?]", login_path, false
    assert_select "a[href=?]", new_user_path, false

  end
end
