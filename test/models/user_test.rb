require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = valid_user(name: 'tom_38', save: false)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'name should be unique (case insensitive)' do
    @user.save
    u = @user.dup
    u.name = u.name.upcase
    assert_not u.valid?
  end

  test 'name should not contain spaces' do
    @user.name = 'tom 38'
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 26
    assert_not @user.valid?
  end

  test 'name should not be too short' do
    @user.name = 'a' * 4
    assert_not @user.valid?
  end

end
