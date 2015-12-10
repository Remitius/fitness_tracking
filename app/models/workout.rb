class WorkoutValidator < ActiveModel::Validator
  def validate(workout)
    if workout.user_id.nil?
      workout.errors[:_] << "Workout's user id doesn't exist (memory)"
    elsif !User.exists?(workout.user_id)
      workout.errors[:_] << "Workout's user id doesn't exist (database)"
    end
  end

end

class Workout < ActiveRecord::Base
  MAX_EXERCISES = 12
  MAX_NAME_LENGTH = 35
  MAX_NOTE_LENGTH = 300
  
  has_many :exercises, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates_date :date, allow_nil: false, 
                 between: ['2012-1-1', 1.year.from_now]
  validates :note, allow_nil: true, length: { maximum: MAX_NOTE_LENGTH }
  validates_with WorkoutValidator
end
