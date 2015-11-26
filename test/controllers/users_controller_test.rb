require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = valid_user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
  end

  test "should get show" do
    get :show, id: @user.id
    assert_response :success
  end

  test 'content of show action' do
    get :show, id: @user.id
    assert_select 'title', /#{@user.username}/
    assert_select "a[href='#{edit_user_path(@user.id)}']", count: 1
  end

  test 'valid creation' do
    User.destroy_all
    assert_difference 'User.count', 1 do 
      post :create, user: { username: 'user12', password: 'hah1234', 
                            password_confirmation: 'hah1234'} 
    end
    assert_redirected_to user_path(User.first)
  end

  test 'invalid creation' do
    assert_no_difference 'User.count' do 
      post :create, user: { username: 'hi' }
    end
    assert_template :new
  end

  test 'valid update' do
    new_username = 'new_name'
    id = @user.id
    put :update, id: id, user: { username: new_username, password: 
                              'jjj111', password_confirmation: 'jjj111' }
    assert_equal new_username, User.find(id).username
  end

  test 'invalid update' do
    old_username = @user.username
    id = @user.id
    put :update, id: id, user: { username: '2' }
    assert_equal old_username, User.find(id).username
  end

  test 'show should redirect to root if invalid id given' do
    get :show, id: 49999
    assert_redirected_to :root
  end

  test 'edit should redirect to root if invalid id given' do
    get :edit, id: 49999
    assert_redirected_to :root
  end
end
