# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit
  include Response
  include Filter
  # protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_user
  before_action :authorized

  private

  attr_reader :current_user

  def authorized
    # if true => login
    unauthorized_response unless logged_in?
  end

  def logged_in?
    validate_token?
  end

  def validate_token?
    return unless request.headers[:token]

    token = LoginToken.find_by(token: request.headers[:token])
    return unless token.present? && token.last_used_on <= Time.current + 1.day

    token.touch(:last_used_on)
    @current_user = token.user
    true
  end

  def unauthorized_user
    forbidden_response
  end
end
