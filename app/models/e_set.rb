class ESetValidator < ActiveModel::Validator
  def validate(set)
    unless set.exercise && Exercise.exists?(set.exercise.id)
      set.errors[:exercise_id] << 'exercise_id is invalid'
    end
    unless set.exercise.e_sets.count < Exercise::MAX_SETS
      set.errors[:base] << 'max number of sets reached'
    end
    unless set.pounds || set.reps
      set.errors[:base] << 'set must include pounds, reps, or both'
    end
  end
end
  
class ESet < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :exercise

  validates :reps, allow_nil: true, 
            numericality: { less_than: 1000, greater_than_or_equal_to: 0 }

  validates :pounds, allow_nil: true, 
            numericality: { less_than: 5000, greater_than_or_equal_to: 0 }

  validates_with ESetValidator                             
end
