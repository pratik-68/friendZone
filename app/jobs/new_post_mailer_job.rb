# frozen_string_literal: true

class NewPostMailerJob < ApplicationJob
  queue_as :default

  # job for sending new post created mail to all subscribers
  #
  # @params {Integer} Post_id
  def perform(post_id)
    post = Post.find_by(id: post_id)
    post_user = post.user
    users = if post.visibility_custom?
              post.user
                  .notification_receipients
                  .joins(:post_users)
                  .where(post_users: { post: post })
            else
              post.user.notification_receipients
            end
    users.each do |user|
      UserMailer.new_post_mail_to_subscriber(post, post_user, user).deliver
    end
  end
end
