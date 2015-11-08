require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  def setup
    @workout = valid_workout(save: true)
  end

  test "index action with no specified exercise" do
    2.times { valid_exercise(@workout, save: true) }
    get :index
    assert_template :index
    assert_select "select"
    assert_select "option", count: 1
    assert_select '#exercise-info', count: 0
  end 

  test "index action when no exercises exist" do
    get :index
    assert_select "option", count: 0
  end

  test "index action select options should be case insensitive" do
    Exercise.create(workout: @workout, name: 'running')
    Exercise.create(workout: @workout, name: 'RUNNING')
    get :index
    assert_select "option", count: 1
  end

  test "index action with a specified exercise" do
    e = valid_exercise(@workout, save: true)
    get :index, name: e.name
    assert_select '#exercise-info', count: 1
  end

  test "index action's info about individual exercises" do
    early_workout = Workout.create(name: 'Workout 1', date: '2014-1-1')
    recent_workout = Workout.create(name: 'Workout 2', date: '2015-2-2')
    exercise_name = 'dbbp'
    e = Exercise.create(workout: early_workout, name: exercise_name)
    Exercise.create(workout: recent_workout, name: exercise_name)
    
    get :index, name: e.name
    @data = assigns(:data)
    assert_match /#{early_workout.date}/, @data[:first_instance]
    assert_match /#{recent_workout.date}/, @data[:last_instance]
    assert_match /2[\s|.|,|"|']/  , @data[:number_of_instances]
  end

  test "index action with a nonexistent specified exercise" do
    get :index, name: 'aaaaa'
    assert_select '#exercise-info', count: 0
  end

end
