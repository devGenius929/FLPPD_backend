class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def welcome_message(user)
    @user = user
    mail to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Welcome to FLPPD"
  end

  def confirm_email(user)
    @user = user
    @confirm_url = "http://0.0.0.0:3000/confirm/#{@user.activation_digest}"
    mail to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Welcome to FLPPD"
  end
end
