require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @workout = valid_workout(save: true)
  end

  test "site header" do
    get new_path
    assert_select 'a[href="/"]', count: 1
  end

  test "link to root path not present in root path's header" do
    get root_path
    assert_select 'a[href="/"]', count: 0
  end

  test "correct workout form elements on workouts#show" do
    get workout_path(@workout)
    assert_select "label[for='workout_name']", count: 1
    assert_select "label[for='workout_date']", count: 1
    assert_select "label[for='workout_note']", count: 1
 end

  test "correct exercise form elements on workouts#show" do
    get workout_path(@workout)
    assert_select "label[for='exercise_name']", count: 1
    assert_select "label[for='exercise_note']", count: 1
 end

  test "correct e_set form elements on workouts#show" do
    get workout_path(@workout)
    assert_select ".e_sets"
    assert_select "a", "add set", count: 1
 end

end
