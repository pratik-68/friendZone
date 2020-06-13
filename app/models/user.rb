# frozen_string_literal: true

class User < ApplicationRecord
  ## ASSOCIATIONS ------------------------------------------
  has_secure_password
  has_secure_token :email_verification_token
  has_secure_token :reset_password_token
  has_one_attached :profile_pic, dependent: :destroy
  has_many :login_tokens, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_users, dependent: :destroy
  has_many :requests, class_name: 'Friend', foreign_key: :requester_id,
                      dependent: :destroy

  ## VALIDATIONS --------------------------------------------
  enum gender: { male: 0, female: 1, other: 2 }

  validates :first_name, :last_name, :gender, :date_of_birth, :email,
            :username, presence: true
  # Email for each user must be unique
  validates :email,
            uniqueness: true,
            format: {
              with: Rails.configuration.VALID_EMAIL_REGXP,
              message: 'Invalid Email address'
            }
  validates :username, :email_verification_token, :reset_password_token,
            uniqueness: true
  validates :first_name, :last_name, length: { maximum: 20 }
  validates :username, length: { in: 3..20 }
  validates :city, length: { in: 3..20 }, allow_blank: true
  validates :profile_pic, image: true
  validates :password, length: { in: 8..20 }, if: :password
  validates :password_confirmation, presence: true, if: :password

  validate :valid_age

  ## CALLBACKS ----------------------------------------------
  before_validation :downcase_fields

  def friends
    Friend.where('user1_id = ? OR user2_id = ?', id, id)
  end

  def friend_users
    User.joins(
      "INNER JOIN friends ON users.id =
      (CASE WHEN friends.user1_id = #{id} THEN friends.user2_id
            WHEN friends.user2_id = #{id} THEN friends.user1_id
      END)"
    )
        .where(
          "(friends.user1_id = ? OR friends.user2_id = ?)
          AND friends.status = ? ", id, id, Friend.statuses[:accepted]
        )
    # User.joins('LEFT JOIN friends f1 ON f1.user1_id = users.id')
    #     .joins('LEFT JOIN friends f2 ON f2.user2_id = users.id')
    #     .where(
    #       '(f1.status = ? AND f1.user2_id = ?) OR
    #       (f2.status = ? AND f2.user1_id = ?)',
    #       Friend.statuses[:accepted], id, Friend.statuses[:accepted], id
    #     )
  end

  def notification_receipients
    User.joins(
      "INNER JOIN friends ON users.id =
      (CASE WHEN friends.user1_id = #{id} THEN friends.user2_id
            WHEN friends.user2_id = #{id} THEN friends.user1_id
      END)"
    )
        .where(
          "friends.status = ? AND ( (friends.notifications = ?) OR
          (friends.user1_id = ? AND friends.notifications = ?) OR
          (friends.user2_id = ? AND friends.notifications = ?) )",
          Friend.statuses[:accepted], Friend.notifications[:to_both],
          id, Friend.notifications[:to_second],
          id, Friend.notifications[:to_first]
        )
    # User.joins('LEFT JOIN friends f1 ON f1.user1_id = users.id')
    #     .joins('LEFT JOIN friends f2 ON f2.user2_id = users.id')
    #     .where(
    #       '(f1.status = ? AND f1.user2_id = ? AND f1.notifications IN (?)) OR
    #       (f2.status = ? AND f2.user1_id = ? AND f2.notifications IN (?))',
    #       Friend.statuses[:accepted], id,
    #       [Friend.notifications[:to_both], Friend.notifications[:to_first]],
    #       Friend.statuses[:accepted], id,
    #       [Friend.notifications[:to_both], Friend.notifications[:to_second]]
    #     )
  end

  private

  def downcase_fields
    email.downcase! if email.present?
  end

  def valid_age
    if date_of_birth.present? && date_of_birth.to_date + 18.years > Date.current
      errors.add(:date_of_birth, 'must be 18 years old')
    end
  end
end
