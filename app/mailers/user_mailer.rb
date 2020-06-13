# frozen_string_literal: true

class UserMailer < ApplicationMailer
  ## for sending verification mail to new user
  #
  # @Params {User}
  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: 'Email Confirmation'
  end

  ## for sending new friend request mail to user
  #
  # @Params {Friend, User} recipient
  def friend_request(friend, recipient)
    @recipient = recipient
    @friend = friend
    @sender = friend.requester
    mail to: @recipient.email, subject: 'New Friend Request'
  end

  ## for sending new post created mail to subscribed user
  #
  # @Params {Post, User, User} post_user, user(recipient)
  def new_post_mail_to_subscriber(post, post_user, user)
    @post = post
    @post_user = post_user
    @user = user
    mail to: @user.email, subject: 'New Post'
  end
end
