# frozen_string_literal: true

class Api::V1::FriendsController < ApplicationController
  before_action :find_user
  skip_before_action :find_user, :authorized, only: [:email_request_accept]

  def create
    authorize @profile_user, policy_class: FriendPolicy

    user = Friend.user_sequence(@profile_user.id, current_user.id)
    friend = Friend.find_by(
      user1_id: user[0],
      user2_id: user[1]
    )

    if friend.present?

      return bad_response(message: 'Already Friend') if friend.accepted?

      unless friend.requester == current_user
        return bad_response(message: 'pending request exists')
      end

      friend.touch(:verification_sent_at)
    else
      friend = Friend.new(
        user1_id: user[0],
        user2_id: user[1],
        requester: current_user,
        status: :pending,
        verification_sent_at: Time.current
      )
    end

    if friend.save
      # job for sending friend request mail
      FriendRequestMailerJob.perform_later(friend.id)
      create_response
    else
      bad_response(friend.errors)
    end
  end

  def update
    authorize @profile_user, policy_class: FriendPolicy

    user = Friend.user_sequence(@profile_user.id, current_user.id)
    friend = Friend.find_by(user1_id: user[0], user2_id: user[1])

    return bad_response(message: 'already accepted') if friend.accepted?

    if friend.update(status: :accepted, accepted_at: Time.current)
      success_response
    else
      bad_response(friend.errors)
    end
  end

  def email_request_accept
    friend = Friend.find_by(verification_token: params[:token])

    return bad_response(message: 'Invalid Link') unless friend.present?

    return bad_response(message: 'Invalid Link') unless friend.pending?

    if friend.update(status: :accepted, accepted_at: Time.current)
      success_response(json_data: { user: { id: friend.requester_id } })
    else
      bad_response(friend.errors)
    end
  end

  def subscribe
    authorize @profile_user, policy_class: FriendPolicy

    user = Friend.user_sequence(@profile_user.id, current_user.id)
    friend = Friend.find_by(user1_id: user[0], user2_id: user[1])

    status = Friend.set_notifications(current_user, user, friend.notifications)

    if friend.update(notifications: status)
      success_response
    else
      bad_response(friend.errors)
    end
  end

  private

  # create instance of requested user
  #
  # params{Integer} User_id
  def find_user
    @profile_user = User.find_by(id: params[:id])

    return bad_response(message: 'Invalid User') unless @profile_user.present?
  end
end
