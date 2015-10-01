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

  validates :name, presence: true, length: { maximum: 40 }
  validates :note, allow_nil: true, length: { maximum: 99 }
  validates_with ExerciseValidator
 end
