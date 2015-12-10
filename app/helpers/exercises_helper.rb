module ExercisesHelper
  def build_graph_start_date_options
    options = {'First occurrence' => nil}
    [1,2,4,6,8,10].each{ |i| options[pluralize(i, 'month') + ' ago'] = i }
    [1,2,3].each{ |i| options[pluralize(i, 'year') + ' ago'] = i*12 }
    options
  end

end
