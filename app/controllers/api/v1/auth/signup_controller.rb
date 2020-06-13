# frozen_string_literal: true

class Api::V1::Auth::SignupController < ApplicationController
  skip_before_action :authorized

  def signup
    user = User.new(signup_params)
    if user.save
      # job for sending verification mail
      EmailerJob.perform_later(user.id)
      return create_response
    end
    bad_response(user.errors)
  end

  private

  def signup_params
    params.require(:user).permit(
      :first_name, :last_name, :gender, :city, :date_of_birth, :email,
      :username, :password, :password_confirmation, :interests, :profile_pic
    )
  end
end
