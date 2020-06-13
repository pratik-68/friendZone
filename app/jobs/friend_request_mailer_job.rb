# frozen_string_literal: true

class FriendRequestMailerJob < ApplicationJob
  queue_as :default

  # job for sending friend request mail to user
  #
  # @params {Integer} Friend_id
  def perform(friend_id)
    friend = Friend.find_by(id: friend_id)
    recipent = friend.requested_user
    UserMailer.friend_request(friend, recipent).deliver
  end
end
