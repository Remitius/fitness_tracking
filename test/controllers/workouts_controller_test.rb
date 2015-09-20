require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  def setup
    @valid_workout = Workout.create(id: 100, name: "Lower Body", 
                                 date: 2.days.ago, note: "great")
    @attr = @valid_workout.attributes
  end

  test "should get index" do
    get :index
    assert_select 'title', 'Tracking | Index'
    assert_response :success
  end

  test "should get index when no workouts exist" do
    Workout.all.each{ |x| x.destroy }
    get :index
    assert_response :success
  end

  test "index should show first 10 workouts by default" do
    get :index
    assert_select 'h3.workout_name', count: 10
    assert_select 'section>h3.workout_name:first-child', @attr[:name]
  end

  test "index should show workouts based on page parameter" do
    get :index, page: 2
    assert_select 'h3.workout_name', count: 10
    get :index, page: 3
    assert_select 'h3.workout_name', count: 2
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

  test "should redirect to index" do
    get :show, id: 99
    assert_response :redirect
  end

  test "show should include workout info if id param is correct" do
    get :show, id: @attr['id']
    assert_template :show
    assert_select 'ul.workout_info', /#{@attr['name']}/i, count: 1
  end

  test "show should redirect to root if invalid id" do
    get :show, id: 9000
    assert_redirected_to :root 
  end

  test "successful update action should correctly update attributes" do
    get :show, id: @attr['id']
    put :update, id: @attr['id'], workout: {name: "HIT", date: 1.day.ago}
    assert_equal 'HIT', Workout.find(@attr['id']).name
    assert_equal 1.day.ago.to_date, Workout.find(@attr['id']).date
    assert_template :show, id: @attr['id']
  end

  test "unsuccessful update action should render show template" do
    put :update, id: @attr['id'], workout: { name: '' }
    assert_equal 'Lower Body', Workout.find(@attr['id']).name
    assert_template :show, id: @attr['id']
  end

  test "saved attributes should display upon unsuccessful update" do
    put :update, id: @attr['id'], workout: { name: '', date: 'hi' }
    assert_select 'ul.workout_info', /#{@attr['name']}/i, count: 1
    assert_select 'ul.workout_info', /#{@attr['date']}/i, count: 1
  end

  test "proper form error messages should display on failed save" do
    put :update, id: @attr['id'], workout: { name: '', note: 'a' * 301 }
    assert_select 'ul.workout_form_errors', /Name can't be blank/i
    assert_select 'ul.workout_form_errors', /Note is too long/i
  end

  test "correct destroy link should exist on show template" do
    get :show, id: @attr['id']
    assert_select 'a[data-method=delete]'
    assert_select "a[href='/workouts/#{@attr['id']}']"
  end

  test "destroy action should remove record from the database" do
    delete :destroy, id: @attr['id']
    assert_raises(ActiveRecord::RecordNotFound) do  
      Workout.find(@attr['id'])
    end 
  end

end
