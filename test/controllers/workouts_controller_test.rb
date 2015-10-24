require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  def setup
    @w = valid_workout(save: true)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', 'Tracking | Index'
  end

  test "should get index when no workouts exist" do
    Workout.destroy_all
    get :index
    assert_response :success
  end

  test "should get first page of index if invalid page param given" do
    get :index, page: -2
    assert_select '.workout_name', count: 10
    assert_select '.workout_name>a', @w.name

    get :index, page: 'hah'
    assert_select '.workout_name', count: 10
    assert_select '.workout_name>a', @w.name
  end

  test "index should show first 10 workouts by default" do
    get :index
    assert_response :success
    assert_select '.workout_name', count: 10
    assert_select '.workout_name>a', @w.name
  end

  test "index should show workouts based on page parameter" do
    get :index, page: 2
    assert_select '.workout_name', count: 10
    get :index, page: 3
    assert_select '.workout_name', count: 2
  end

  test "index should contain links to previous and next page" do
    get :index, page: 2
    assert_select "a[href='#{root_path}?page=1']"
    assert_select "a[href='#{root_path}?page=3']"
  end

  test "first page of index should contain next page link" do
    get :index
    assert_select "a[href='#{root_path}?page=2']"
    assert_select "a[href='#{root_path}?page=0']", false

    get :index, page: 1
    assert_select "a[href='#{root_path}?page=2']"
    assert_select "a[href='#{root_path}?page=0']", false
  end

  test "index response should be valid if workout list is empty" do
    get :index, page: 5000
    assert_response :success 
  end

  test "should get new" do
    get :new
    assert_select 'title', 'Tracking | New Workout'
    assert_response :success
  end

  test "should get show" do
    w = Workout.create(id: 101, name: 'a' * 14, date: 1.day.ago)
    get :show, id: w.id
    assert_select 'title', "Tracking | #{'a' * 13}"
    assert_response :success
  end  

  test "show should include workout info if id param is correct" do
    get :show, id: @w.id
    assert_template :show
    assert_select '.workout_info', /#{@w.name}/i, count: 1
  end

  test "show should redirect to root if id is invalid" do
    get :show, id: 9000
    assert_redirected_to :root 
  end

  test "successful update should properly update attributes" do
    put :update, id: @w.id, workout: {name: "HIT", date: 1.day.ago}
    assert_equal 'HIT', Workout.find(@w.id).name
    assert_equal 1.day.ago.to_date, Workout.find(@w.id).date
    assert_template :show, id: @w.id
  end

  test "unsuccessful update should render show template" do
    old_name = @w.name
    put :update, id: @w.id, workout: { name: '' }
    assert_equal old_name, Workout.find(@w.id).name
    assert_template :show, id: @w.id
  end

  test "saved attributes should display upon unsuccessful update" do
    put :update, id: @w.id, workout: { name: '', date: 'hi' }
    assert_select '.workout_info', /#{@w.name}/i, count: 1
    assert_select '.workout_info', /#{@w.date}/i, count: 1
  end

  test "proper form error messages should display on failed save" do
    put :update, id: @w.id, workout: { name: '', note: 'a' * 301 }
    assert_select "div.flash_error", /Name can't be blank/i
    assert_select "div.flash_error", /Note is too long/i
  end

  test "destroy link should exist on show template" do
    get :show, id: @w.id
    assert_select 'a[data-method=delete]'
    assert_select "a[href='/workouts/#{@w.id}']"
  end

  test "destroy should remove workout from the database" do
    delete :destroy, id: @w.id
    assert_raises(ActiveRecord::RecordNotFound) do  
      Workout.find(@w.id)
    end 
  end

  test "valid creation" do
    get :new
    Workout.destroy_all
    assert_difference 'Workout.count', 1 do
      w = post :create, workout: { name: 'HIIT', date: '2015-1-1' }
    end
    assert_redirected_to workout_path(Workout.first)
  end

  test "invalid creation" do
    get :new
    assert_no_difference 'Workout.count' do 
      post :create, workout: { date: '2040-1-1' }
    end
    assert_template :new
    assert_select ".flash_error", /Name can't be blank/i
    assert_select ".flash_error", /Date must be on or/i
  end

end
