class ExerciseSetValidator < ActiveModel::Validator
  def validate(set)
    unless set.exercise && Exercise.exists?(set.exercise.id)
      set.errors[:exercise_id] << 'exercise_id is invalid'
    end
  end
end
  
class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  validates :reps, allow_nil: true, 
            numericality: { less_than: 1000, greater_than_or_equal_to: 0 }

  validates :pounds, allow_nil: true, 
            numericality: { less_than: 5000, greater_than_or_equal_to: 0 }
  validates_with ExerciseSetValidator                             
end
