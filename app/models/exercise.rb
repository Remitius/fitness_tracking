class ExerciseValidator < ActiveModel::Validator
  def validate(exercise)
    unless exercise.workout && Workout.exists?(exercise.workout.id)
      exercise.errors[:workout_id] << 'workout_id is invalid'
    end
    unless exercise.workout.exercises.count < Workout::MAX_EXERCISES
      exercise.errors[:base] << 'max number of exercises reached'
    end
  end

end

class Exercise < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :workout
  has_many :exercise_sets, dependent: :destroy

  validates :name, presence: true, length: { maximum: 40 }
  validates :note, allow_nil: true, length: { maximum: 99 }
  validates_with ExerciseValidator
 end

