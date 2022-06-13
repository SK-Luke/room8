require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "add-Flatmates" do
    mail = UserMailer.add-Flatmates
    assert_equal "Add-flatmates", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
