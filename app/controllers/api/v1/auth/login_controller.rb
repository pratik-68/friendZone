# frozen_string_literal: true

class Api::V1::Auth::LoginController < ApplicationController
  skip_before_action :authorized, only: [:login]

  def login
    unless login_parameter[:email].present?
      return bad_response(email: 'Email can\'t be empty')
    end

    unless login_parameter[:password].present?
      return bad_response(password: 'Password can\'t be empty')
    end

    email = login_parameter[:email].downcase
    user = User.find_by(email: email)

    unless user&.authenticate(login_parameter[:password])
      return bad_response(message: 'Invalid email or password')
    end

    login_token = LoginToken.new(user_id: user.id)
    if login_token.save
      user.touch(:last_login_at)
      success_response(json_data: login_token)
    else
      bad_response(login_token.errors)
    end
  end

  def logout
    token = LoginToken.find_by(token: request.headers[:token])
    if token.destroy
      success_response
    else
      bad_response(token.errors)
    end
  end

  private

  def login_parameter
    params.require(:user).permit(:email, :password)
  end
end
