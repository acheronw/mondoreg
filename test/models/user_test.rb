require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Teszt Béla", email: "bela@teszt.com", language: "HU")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 101
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = ["teszt@bela.hu", "TESZT@bela.com", "T_ES-ZT@be.la.co.uk", "teszt.bela@gmail.com", "te+szt@bela.com"]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = ["teszt@bela,com", "teszt.bela.hu", "teszt@bela", "teszt@be_la.hu", "teszt@be+la.hu",
                         "teszt@bela..com"]
    invalid_addresses.each do | invalid_address |
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be downcased when saved" do
    camelcase_email = "Bela@Teszt.HU"
    @user.email = camelcase_email
    @user.save
    assert_equal camelcase_email.downcase, @user.reload.email

  end


end
