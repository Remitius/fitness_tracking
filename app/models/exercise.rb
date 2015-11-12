class ExerciseValidator < ActiveModel::Validator
  def validate(exercise)
    unless exercise.workout && Workout.exists?(exercise.workout.id)
      exercise.errors[:_] << 'workout_id is invalid'
    end
    unless exercise.workout.exercises.count < Workout::MAX_EXERCISES
      exercise.errors[:_] << 'Max number of exercises reached'
    end
  end

end

class Exercise < ActiveRecord::Base
  MAX_NAME_LENGTH = 40
  MAX_NOTE_LENGTH = 100
  belongs_to :workout
  has_many :e_sets, dependent: :destroy
  accepts_nested_attributes_for :e_sets

  include ActiveModel::Validations
  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :note, allow_nil: true, length: { maximum: MAX_NOTE_LENGTH }
  validates_with ExerciseValidator
 end

