class Workout < ActiveRecord::Base
  MAX_EXERCISES = 12
  has_many :exercises, dependent: :destroy
  validates :name, presence: true, length: { maximum: 35 }
  validates_date :date, allow_nil: false, 
                 between: ['2012-1-1', 1.year.from_now]
  validates :note, allow_nil: true, length: { maximum: 300 }
end
