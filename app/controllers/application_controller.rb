# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def cors_preflight_check
    return unless request.method == 'OPTIONS'

    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, '\
                                              'X-Prototype-Version, Token'
    headers['Access-Control-Max-Age'] = '1728000'
    render text: '', content_type: 'text/plain'
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, '\
                                              'Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
