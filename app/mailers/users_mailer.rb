# frozen_string_literal: true

class UsersMailer < ApplicationMailer
  def reset_password_instructions(user, token)
    @user = user
    @token = token
    mail subject: 'Reset Password',
         to: "#{@user.full_name} <#{@user.email}>"
  end
end
