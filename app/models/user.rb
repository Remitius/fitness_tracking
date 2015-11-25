class User < ActiveRecord::Base
  validates :username, presence: true, length: { minimum: 5, maximum: 25 }, 
    format: { with: /\A\S*\z/ }, uniqueness: { case_sensitive: false }
end
