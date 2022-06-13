# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/add-Flatmates
  def welcome
    user = User.find_by(email: "kken.w@hotmail.com")
    UserMailer.welcome(user)
  end

end
