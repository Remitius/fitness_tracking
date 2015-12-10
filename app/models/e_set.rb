class ESetValidator < ActiveModel::Validator
  def validate(set)
    unless set.pounds || set.reps
      set.errors[:_] << 'Must include pounds, reps, or both'
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
