# frozen_string_literal: true

class Post < ApplicationRecord
  ## ASSOCIATIONS ------------------------------------------
  belongs_to :user
  has_one_attached :image, dependent: :destroy
  has_many :post_users, dependent: :destroy
  has_many :users, through: :post_users

  ## VALIDATIONS --------------------------------------------
  enum visible_to: { public: 0, friends: 1, personal: 2, custom: 3 },
       _prefix: :visibility
  validates :description, :visible_to, presence: true
  validates :image, image: true

  def self.visible_posts(current_user, profile_user)
    if current_user.id == profile_user.id
      current_user.posts
    else
      user = Friend.user_sequence(profile_user.id, current_user.id)
      is_friend = Friend.exists?(user1_id: user[0], user2_id: user[1],
                                 status: :accepted)

      if is_friend
        profile_user.posts.left_joins(:post_users)
                    .where(post_users: { user_id: current_user.id })
                    .or(profile_user.posts.left_joins(:post_users)
                              .where(visible_to: %i[public friends]))

      else
        profile_user.posts
                    .where(visible_to: :public)
      end
    end
  end

  def self.all_posts(current_user)
    Post.joins('LEFT JOIN users ON users.id = posts.user_id')
        .joins('LEFT JOIN friends f1 ON f1.user1_id = users.id')
        .joins('LEFT JOIN friends f2 ON f2.user2_id = users.id')
        .left_joins(:post_users)
        .where(
          '(posts.user_id = ?) OR (post_users.user_id =?)
            OR (f1.status = ? AND f1.user2_id = ? AND posts.visible_to IN (?))
            OR (f2.status = ? AND f2.user1_id = ? AND posts.visible_to IN (?))',
          current_user.id, current_user.id,
          Friend.statuses[:accepted], current_user.id,
          [Post.visible_tos[:public], Post.visible_tos[:friends]],
          Friend.statuses[:accepted], current_user.id,
          [Post.visible_tos[:public], Post.visible_tos[:friends]]
        )
        .distinct
  end
end
