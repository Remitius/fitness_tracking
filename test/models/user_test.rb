require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = valid_user(username: 'tom_38', save: false)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'username should be present' do
    @user.username = ''
    assert_not @user.valid?
  end

  test 'username should be unique (case insensitive)' do
    @user.save
    u = @user.dup
    u.username = u.username.upcase
    assert_not u.valid?
  end

  test 'username should not contain spaces' do
    @user.username = 'tom 38'
    assert_not @user.valid?
  end

  test 'username should not be too long' do
    @user.username = 'a' * 26
    assert_not @user.valid?
  end

  test 'username should not be too short' do
    @user.username = 'a' * 4
    assert_not @user.valid?
  end

end
