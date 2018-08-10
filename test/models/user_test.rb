require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be valid" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    correct_email = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    correct_email.each do |cor_email|
      @user.email = cor_email
      assert @user.valid?, "#{cor_email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid address" do
    incorrect_email = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    incorrect_email.each do |incr_email|
      @user.email = incr_email
      assert_not @user.valid?, "#{incr_email.inspect} should be invalid"
    end
  end


  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?

  end

  test "password should be minimum of six char" do
    @user.password = @user.password_confirmation = "a"*5

    assert_not @user.valid?
  end


end
