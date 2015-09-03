class Workout < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 35 }

  #date ('yyyy-mm-dd'): range 1/1/2000 to 2 years ahead
  #ensure date is of date class
  validates :date, presence: true

  validates :note, allow_nil: true, length: { maximum: 300 }
end
