# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  serialization_scope :current_user

  def index
    authorize Post
    page = params.fetch(:page, 1).to_i

    return bad_response(message: 'Invalid Request') unless page.positive?

    posts = filter(
      record: current_user.posts,
      page: page,
      order: { created_at: :desc }
    )
    count = current_user.posts.count

    success_response(json_data: posts, meta_data: { total_count: count })
  end

  def user_posts
    page = params.fetch(:page, 1).to_i

    return bad_response(message: 'Invalid Request') unless page.positive?

    profile_user = User.find_by(id: params[:id])

    return forbidden_response unless profile_user.present?

    post = filter(
      record: Post.visible_posts(current_user, profile_user),
      page: page,
      order: { created_at: :desc }
    )
    count = Post.visible_posts(current_user, profile_user)
                .count

    success_response(json_data: post, meta_data: { total_count: count })
  end

  def friend_posts
    page = params.fetch(:page, 1).to_i

    return bad_response(message: 'Invalid Request') unless page.positive?

    authorize Post

    posts = filter(
      record: Post.all_posts(current_user),
      page: page,
      order: { created_at: :desc }
    )

    count = Post.all_posts(current_user).count

    success_response(json_data: posts, meta_data: { total_count: count })
  end

  def create
    authorize Post

    post = Post.new(post_params)
    post.user = current_user

    if post.valid? && post.visibility_custom?
      user_list = user_params[:ids]

      return bad_response(user: 'provide user list') unless user_list.present?
      return bad_response(user: 'cant be blank') if user_list.empty?

      user_list.map!(&:to_i)
      unless user_list.length == user_list.uniq.length
        return bad_response(user: 'dublicate users')
      end

      friend_ids = current_user.friend_users.map(&:id)
      unless (user_list - friend_ids).empty?
        return bad_response(user: 'Invalid User')
      end

      post_users = []
      user_list.each do |user|
        post_user = {
          post: post,
          user_id: user
        }
        post_users << PostUser.new(post_user)
      end
    end

    if post.save
      PostUser.import post_users, validate: true if post.visibility_custom?

      # job for sending mails to all subscriber
      NewPostMailerJob.perform_later(post.id) unless post.visibility_personal?
      return create_response(post)
    end
    bad_response(post.errors)
  end

  def update
    post = Post.find_by(id: params[:id])

    return forbidden_response unless post.present?

    authorize post

    return success_response(json_data: post) if post.update(post_params)

    bad_response(post.errors)
  end

  def show
    post = Post.find_by(id: params[:id])

    return not_found_response unless post.present?

    authorize post

    success_response(json_data: post)
  end

  private

  def post_params
    params.require(:post).permit(:image, :description, :visible_to)
  end

  def user_params
    params.require(:user).permit(ids: [])
  end
end
