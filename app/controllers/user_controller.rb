# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate!, except: :create

  def show
    render json: current_user
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :bad_request
    end
  end

  def update
    @user = current_user
    if @user.update_without_password(account_update_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages },
             status: :bad_request
    end
  end

  def change_password
    @user = current_user
    if @user.update_with_password(password_change_params)
      render json: { message: 'Password has been successfully changed!' }
    else
      render json: { errors: @user.errors.full_messages },
             status: :bad_request
    end
  end

  private

    def sign_up_params
      params.require(:user).permit %i[
        email
        password
        password_confirmation
        full_name
        username
      ]
    end

    def account_update_params
      params.require(:user).permit %i[
        email
        full_name
        username
        dark_mode
      ]
    end

    def password_change_params
      params.require(:user).permit %i[
        password
        password_confirmation
        current_password
      ]
    end
end
