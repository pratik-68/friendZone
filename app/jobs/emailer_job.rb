# frozen_string_literal: true

class EmailerJob < ApplicationJob
  queue_as :default

  # job for sending verification mail to new user
  #
  # @params {Integer} user_id
  def perform(user_id)
    user = User.find_by(id: user_id)
    UserMailer.email_confirmation(user).deliver
  end
end
