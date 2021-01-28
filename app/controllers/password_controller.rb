# frozen_string_literal: true

class PasswordController < APIController
  skip_before_action :authenticate_user!

  # receive Password Reset request
  def forgot
    @user = User.active.find_by(email: params[:email])
    @user.send_reset_password_instructions if @user.present?
    render json: t('devise.passwords.send_instructions')
  end

  # reset Password for user
  def reset
    @user = User.reset_password_by_token(reset_password_params)

    if @user.errors.empty?
      render json: t('devise.passwords.updated_not_active')
    else
      render json: errors_json(@user.errors.full_messages),
             status: :unprocessable_entity
    end
  end

  private

    def reset_password_params
      params.permit(:reset_password_token, :password, :password_confirmation)
    end
end
