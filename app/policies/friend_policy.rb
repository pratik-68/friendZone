# frozen_string_literal: true

class FriendPolicy < ApplicationPolicy
  def create?
    return false if owner? || users_unverified?

    true
  end

  def update?
    return true if friend_request_requester?
  end

  def subscribe?
    friend_request_accepted?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  ## check if post is of current_user
  def owner?
    record.id == user.id
  end

  # check if any user is unverified
  #
  # @params (User) record(profile_user), user(current_user)
  # @return {Boolean}
  def users_unverified?
    !record.is_verified? || !user.is_verified?
  end

  #  check friend request exists
  #
  # @params {User} record(profile_user), user(current_user)
  # @return {boolean}
  def friend_request_exists?
    users = Friend.user_sequence(record.id, user.id)
    @friend = Friend.find_by(user1_id: users[0], user2_id: users[1])
    @friend.present?
  end

  # check if friend request requester is profile user
  def friend_request_requester?
    friend_request_exists? && friend.requester == record
  end

  # check if friend request status is accepted
  def friend_request_accepted?
    friend_request_exists? && friend.accepted?
  end

  def friend
    users = Friend.user_sequence(record.id, user.id)
    @friend ||= Friend.find_by(user1_id: users[0], user2_id: users[1])
  end
end
