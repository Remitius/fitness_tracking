require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  test "index action" do
     get :index
     assert_template :index
   end 
end
