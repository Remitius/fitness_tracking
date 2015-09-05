class ExerciseValidator < ActiveModel::Validator
  def validate(exercise)
    unless exercise.workout && Workout.exists?(exercise.workout.id)
      exercise.errors[:workout_id] << 'workout_id is invalid'
    end
  end
end

class Exercise < ActiveRecord::Base
  belongs_to :workout
  include ActiveModel::Validations
  before_save { name.downcase! }
  validates :name, presence: true, length: { maximum: 40 }

  validates :sets, allow_nil: true, numericality: { less_than: 1000, 
            greater_than_or_equal_to: 0 }

  validates :repetitions, allow_nil: true, 
            numericality: { less_than: 1000, greater_than_or_equal_to: 0 }

  validates :seconds, allow_nil: true, numericality: { less_than: 100000, 
            greater_than_or_equal_to: 0}

  validates :note, allow_nil: true, length: { maximum: 99 }

 
  validates_with ExerciseValidator
end

