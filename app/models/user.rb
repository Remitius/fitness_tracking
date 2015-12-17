class User < ActiveRecord::Base
  has_many :workouts, dependent: :destroy
  has_secure_password

  validates :password, length: { minimum: 6, maximum: 30 }
  validates :username, presence: true, length: { minimum: 5, maximum: 25 }, 
    format: { with: /\A\S*\z/ }, uniqueness: { case_sensitive: false }

  def exercise_count
    count = 0
    self.workouts.each do |w|
      count += w.exercises.count
    end
    count
  end
end
