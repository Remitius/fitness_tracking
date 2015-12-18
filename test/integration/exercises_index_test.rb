require 'test_helper'

class ExercisesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @w = valid_workout
    log_in_user(@w.user)
  end

  test "index action with no specified exercise" do
    2.times { valid_exercise(@w) }
    get exercises_index_path
    assert_template 'exercises/index'
    assert_select 'select'
    assert_select 'option', count: 1
    assert_select '#exercise-info', false
  end 

  test "index action when no exercises exist" do
    get exercises_index_path
    assert_select 'option', false
  end

  test "index action select options should be case insensitive" do
    valid_exercise(@w, name: 'run')
    valid_exercise(@w, name: 'RUN')
    get exercises_index_path
    assert_select 'option', count: 1
  end

  test "index with a specified exercise" do
    e = valid_exercise(@w)
    get exercises_index_path, name: e.name
    assert_select '#exercise-info', count: 1
  end

  test "index info about exercise's first and last occurences" do
    early_workout = valid_workout(date: '2014-1-1', user: @w.user)
    recent_workout = valid_workout(date: '2015-2-2', user: @w.user)
    e = Exercise.create(workout: early_workout, name: 'dbbp')
    Exercise.create(workout: recent_workout, name: e.name)
    
    get exercises_index_path, name: e.name
    data = assigns(:exercise_data)
    assert_equal early_workout.date, data[:first_instance][:date]
    assert_equal recent_workout.date, data[:last_instance][:date]
    assert_select '#first-instance', count: 1
    assert_select '#last-instance', count: 1
    assert_select "a[href='#{workout_path(early_workout)}']", count: 1
    assert_select "a[href='#{workout_path(recent_workout)}']", count: 1
  end

  test "index info about exercise's number of occurences" do
    e = valid_exercise(@w)    
    valid_exercise(@w)
    get exercises_index_path, name: e.name

    data = assigns(:exercise_data)
    assert_equal 2, data[:number_of_instances]
    assert_select '#number-of-instances'
  end

  test "index info about individual exercises' sets" do
    e1 = valid_exercise(@w, name: 'dbbp')
    e2 = valid_exercise(@w, name: e1.name)
    get exercises_index_path, name: e1.name

    assert_select '#lightest-set', false
    assert_select '#heaviest-set', false

    valid_e_set(e1, pounds: 10, reps: nil)
    valid_e_set(e2, pounds: 200, reps: 2)
    get exercises_index_path, name: e1.name

    data = assigns(:exercise_data)
    assert_equal 10, data[:lightest_set][:pounds]
    assert_equal nil, data[:lightest_set][:reps]

    assert_equal 200, data[:heaviest_set][:pounds]
    assert_equal 2, data[:heaviest_set][:reps]

    assert_select '#lightest-set'
    assert_select '#heaviest-set'
    assert_select "#lightest-set>a[href='#{workout_path(data[:lightest_set][:workout_id])}']"
    assert_select "#heaviest-set>a[href='#{workout_path(data[:heaviest_set][:workout_id])}']"
  end

  test "index action with a nonexistent specified exercise" do
    get exercises_index_path, name: 'aaaaa'
    assert_select '#exercise-info', false
  end

  test 'index action - table of e_sets for particular exercise' do
    e = valid_exercise(@w)
    s = valid_e_set(e, pounds: 2, reps: 3)
    get exercises_index_path, name: e.name, view: 'table'

    assert_select 'table#e-set-instances', count: 1
    assert_select 'td', /#{s.reps}/, count: 1
    assert_select 'td', /#{s.pounds}/, count: 1
    assert_select "td>a[href='#{workout_path(e.workout_id)}']", count: 1
  end

  test "index e_sets table shouldn't exist when no e_sets exist in db" do
    e = valid_exercise(@w)
    get exercises_index_path, name: e.name
    assert_select 'table#e-set-instances', count: 0
  end

  test 'index should display line graph or table based on view param' do
    e = valid_exercise(@w)
    valid_e_set(e)
    
    get exercises_index_path, name: e.name
    assert_select '#line-graph'

    get exercises_index_path, name: e.name, view: 'table'
    assert_select '#line-graph', false
  end

  test 'index with line graph view should only display heaviest daily sets' do
    e = valid_exercise(@w)
    heaviest = ESet.create(exercise: e, pounds: 3)
    ESet.create(exercise: e, pounds: 1)
    ESet.create(exercise: e, reps: 20)    
    get exercises_index_path, name: e.name, view: 'line'

    data = assigns(:exercise_data)
    assert_equal 1, data[:formatted_sets].length
    assert_not data[:formatted_sets][0][:reps]
    assert_equal heaviest.pounds, data[:formatted_sets][0][:pounds]
    assert_equal @w.id, data[:formatted_sets][0][:workout_id]
    assert_equal @w.date.to_s, data[:formatted_sets][0][:date]
  end

  test "index line graph's start date parameter (1 month)" do
    recent_workout = valid_workout(user: @w.user, date: 15.days.ago)
    recent_set = valid_e_set(valid_exercise(recent_workout), pounds: 7)

    valid_e_set(valid_exercise(valid_workout(user: @w.user, date: 1.months.ago - 1.day)))

    get exercises_index_path, name: recent_set.exercise.name, view: 'line', start_date: 1
    data = assigns(:exercise_data)
    assert_equal 1, data[:formatted_sets].length
    assert_equal recent_set.pounds, data[:formatted_sets][0][:pounds]
  end

  test "index line graph's start date parameter (1 year)" do
    recent_workout = valid_workout(user: @w.user, date: 15.days.ago)
    recent_set = valid_e_set(valid_exercise(recent_workout), pounds: 7)

    valid_e_set(valid_exercise(valid_workout(user: @w.user, date: 12.months.ago - 1.day)))

    get exercises_index_path, name: recent_set.exercise.name, view: 'line', start_date: 12
    data = assigns(:exercise_data)
    assert_equal 1, data[:formatted_sets].length
    assert_equal recent_set.pounds, data[:formatted_sets][0][:pounds]
  end

end

