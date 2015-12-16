require 'test_helper'

class UserWorkoutsTest < ActionDispatch::IntegrationTest
  def setup
    @w = valid_workout
    log_in_user(@w.user)
  end

  test "should get index" do
    get workouts_path
    assert_response :success
    assert_select 'title', 'Tracking | Index'
  end

  test "should get index when no workouts exist" do
    Workout.destroy_all
    get workouts_path
    assert_response :success
  end

  test "should get first page of index if invalid page param given" do
    9.times { valid_workout(user: @w.user) }
    get workouts_path, page: -2
    assert_select '.workout-entry', count: 10
    assert_select '.workout-entry>a', /#{@w.name}/

    get workouts_path, page: 'hah'
    assert_select '.workout-entry', count: 10
    assert_select '.workout-entry>a', /#{@w.name}/
  end

  test "index should show first 10 workouts by default" do
    15.times { valid_workout(user: @w.user) }
    get workouts_path
    assert_response :success
    assert_select '.workout-entry', count: 10
    assert_select '.workout-entry>a', /#{@w.name}/
  end

  test "index should show workouts based on page parameter" do
    21.times { valid_workout(user: @w.user) }
    get workouts_path, page: 2
    assert_select '.workout-entry', count: 10
    get workouts_path, page: 3
    assert_select '.workout-entry', count: 2
  end

  test "index should contain links to previous and next page" do
    21.times { valid_workout(user: @w.user) }
    get workouts_path, page: 2
    assert_select "a[href='#{root_path}?page=1']"
    assert_select "a[href='#{root_path}?page=3']"
  end

  test "first page of index should contain next page link" do
    13.times { valid_workout(user: @w.user) }
    get workouts_path
    assert_select "a[href='#{root_path}?page=2']"
    assert_select "a[href='#{root_path}?page=0']", false

    get workouts_path, page: 1
    assert_select "a[href='#{root_path}?page=2']"
    assert_select "a[href='#{root_path}?page=0']", false
  end

  test 'last page of index should not contain a next page link' do
    get workouts_path, page: 3
    assert_select "a[href='#{root_path}?page=4']", false
    assert_select "a[href='#{root_path}?page=2']"
  end

  test "index response should be valid if workout list is empty" do
    get workouts_path, page: 5000
    assert_response :success 
  end

  test "should get new" do
    get new_workout_path
    assert_select 'title', 'Tracking | New Workout'
    assert_response :success
  end

  test "edit should redirect to root if id is invalid" do
    get edit_workout_path(9000)
    assert_redirected_to :root 
  end

  test "should get show" do
    w = Workout.create(name: 'a', date: 1.day.ago, user: @w.user)
    get workout_path(w.id)
    assert_select 'title', "Tracking | a"
    assert_response :success
  end  

  test "show should include workout info if id param is correct" do
    get workout_path(@w.id)
    assert_template 'workouts/show'
    assert_select '#left-sidebar', /#{@w.name}/i, count: 1
    assert_select '#left-sidebar', /#{@w.note}/i, count: 1
    assert_select '#left-sidebar', /#{@w.note}/i, count: 1
  end

  test "show should redirect to root if id is invalid" do
    get workout_path(9000)
    assert_redirected_to :root 
  end

  test "successful update should properly update attributes" do
    put workout_path(@w), workout: { name: "HIT", date: 1.day.ago }
    assert_equal 'HIT', Workout.find(@w.id).name
    assert_equal 1.day.ago.to_date, Workout.find(@w.id).date
    assert_template 'workouts/show'
  end

  test "unsuccessful update should render edit template" do
    old_name = @w.name
    put workout_path(@w), workout: { name: '' }
    assert_equal old_name, Workout.find(@w.id).name
    assert_template 'workouts/edit'
  end

  test "proper form error messages should display on failed save" do
    put workout_path(@w), workout: { name: '', note: 'a' * 301 }
    assert_select "#flash_error", /Name can't be blank/i
    assert_select "#flash_error", /Note is too long/i
  end

  test "destroy link should exist on show template" do
    get workout_path(@w.id)
    assert_select 'a[data-method=delete]'

    assert_select "a[href='#{workout_path(@w.id)}']"
  end

  test "destroy should remove workout from the database" do
    delete workout_path(@w)
    assert_raises(ActiveRecord::RecordNotFound) do  
      Workout.find(@w.id)
    end 
  end

  test "valid creation" do
    Workout.destroy_all
    assert_difference 'Workout.count', 1 do
      post workouts_path, workout: valid_workout(save: false).attributes
    end
    assert_redirected_to workout_path(Workout.first)
  end

  test "invalid creation" do
    assert_no_difference 'Workout.count' do 
      post workouts_path, workout: { date: '2040-1-1' }
    end
    assert_template 'workouts/new'
    assert_select "#flash_error", /Name can't be blank/i
    assert_select "#flash_error", /Date must be on or/i
  end

end

