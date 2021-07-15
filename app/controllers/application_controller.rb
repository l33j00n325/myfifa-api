# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

    def current_user
      @current_user ||= User.find_by(id: doorkeeper_token&.resource_owner_id)
    end

    def authenticate!
      return if current_user.present?

      render json: { errors: ['User is not authenticated!'] },
             status: :unauthorized
    end
end
