require 'test_helper'

class EmailsTest < ActionMailer::TestCase
  test "beta_invite" do
    @expected.subject = 'Emails#beta_invite'
    @expected.body    = read_fixture('beta_invite')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_beta_invite(@expected.date).encoded
  end

  test "welcome" do
    @expected.subject = 'Emails#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_welcome(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'Emails#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_forgot_password(@expected.date).encoded
  end

  test "change_email" do
    @expected.subject = 'Emails#change_email'
    @expected.body    = read_fixture('change_email')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_change_email(@expected.date).encoded
  end

  test "change_password" do
    @expected.subject = 'Emails#change_password'
    @expected.body    = read_fixture('change_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_change_password(@expected.date).encoded
  end

  test "weekly_update" do
    @expected.subject = 'Emails#weekly_update'
    @expected.body    = read_fixture('weekly_update')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Emails.create_weekly_update(@expected.date).encoded
  end

end
