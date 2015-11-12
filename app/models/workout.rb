class Workout < ActiveRecord::Base
  MAX_EXERCISES = 12
  MAX_NAME_LENGTH = 35
  MAX_NOTE_LENGTH = 300
  has_many :exercises, dependent: :destroy
  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates_date :date, allow_nil: false, 
                 between: ['2012-1-1', 1.year.from_now]
  validates :note, allow_nil: true, length: { maximum: MAX_NOTE_LENGTH }
end
