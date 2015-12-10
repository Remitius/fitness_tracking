class User < ActiveRecord::Base
  has_many :workouts, dependent: :destroy
  has_secure_password

  validates :password, length: { minimum: 6, maximum: 30 }
  validates :username, presence: true, length: { minimum: 5, maximum: 25 }, 
    format: { with: /\A\S*\z/ }, uniqueness: { case_sensitive: false }
end
