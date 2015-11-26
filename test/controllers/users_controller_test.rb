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

end
