class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.add-Flatmates.subject
  #
  def welcome(user, current_user, flat)
    @user = user
    @current_user = current_user
    @flat = flat
    # @flat = user.flats
    mail(
      to: user.email, 
      subject: "You've got an invite from #{current_user.name}!
      ")
  end
end
