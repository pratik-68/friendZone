# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :city, :gender, :date_of_birth,
             :interests, :username, :profile_pic
  attribute :email
  attribute :is_owner
  attribute :verified
  attribute :is_friend, if: :other_user_profile?
  attribute :can_request, if: :other_user_profile?
  attribute :is_requested, if: :other_user_profile?
  attribute :has_request, if: :other_user_profile?
  attribute :is_subscribed, if: :other_user_profile?

  # user profile pic
  def profile_pic
    return unless object.profile_pic.attached?

    ## retrive image details from active storage
    object.profile_pic.blob.attributes
          .slice('filename', 'byte_size')
          .merge(url: image_url)
          .tap { |attrs| attrs['name'] = attrs.delete('filename') }
  end

  ## return url for object image
  def image_url
    url_for(object.profile_pic)
  end

  # check if user is verified or not
  def verified
    object.is_verified?
  end

  # check if record is of current user
  def is_owner
    object == current_user
  end

  # check if record is of another user
  def other_user_profile?
    !is_owner
  end

  # check if current user can send friend request
  def can_request
    return true if is_requested

    return true if both_user_verified? && !friend_request_exists?

    false
  end

  # check if current user has sent friend request
  def is_requested
    request_status_pending? && @friend.requester == current_user
  end

  # check if current user has pending friend request
  def has_request
    request_status_pending? && @friend.requester != current_user
  end

  # check if both user already friends
  def is_friend
    friend_request_exists? && @friend.accepted?
  end

  def is_subscribed
    return false unless friend_request_exists? && @friend.accepted?

    return true if @friend.to_both?

    if @friend.user1 == current_user
      @friend.to_first?
    else
      @friend.to_second?
    end
  end

  private

  # check if both user are verified
  def both_user_verified?
    current_user.is_verified? && object.is_verified?
  end

  # check if friend request exists
  def friend_request_exists?
    both_user_verified?
    users = Friend.user_sequence(object.id, current_user.id)
    @friend = Friend.find_by(user1_id: users[0], user2_id: users[1])
    @friend.present?
  end

  # check if friend request status is pendind?
  def request_status_pending?
    friend_request_exists? && @friend.pending?
  end
end
