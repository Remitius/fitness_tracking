require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should show first 10 workouts by default" do
    get :index
    assert_select 'span#workout_name', count: 10
  end

  test "index should show workouts based on page parameter" do
    #based on 22 fixtures
    get :index, page: 2
    assert_select 'span#workout_name', count: 10
    get :index, page: 3
    assert_select 'span#workout_name', count: 2
  end

  test "index response should be valid if workout list is empty" do
    get :index, page: 5000
    assert_response :success 
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
