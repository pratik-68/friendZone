# frozen_string_literal: true

class Friend < ApplicationRecord
  ## ASSOCIATIONS ------------------------------------------
  has_secure_token :verification_token
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User' # user1_id < user2_id
  belongs_to :requester, class_name: 'User'

  enum notifications: { to_none: 0, to_first: 1, to_second: 2, to_both: 3 }
  enum status: { pending: 0, accepted: 1 }

  ## VALIDATIONS --------------------------------------------
  validates :verification_token, uniqueness: true
  validates :user1_id, :user2_id, :requester_id, presence: true
  validates :user1_id, uniqueness: { scope: :user2_id }

  validate :validate_users

  def requested_user
    id = user1_id != requester_id ? user1_id : user2_id
    User.find_by(id: id)
  end

  def self.user_sequence(user1_id, user2_id)
    [user1_id, user2_id].sort
  end

  def self.set_notifications(current_user, user, current_status)
    case current_status
    when 'to_none'
      status = current_user.id == user[0]  ? :to_first : :to_second
    when 'to_first'
      status = current_user.id == user[0]  ? :to_none : :to_both
    when 'to_second'
      status = current_user.id == user[0]  ? :to_both : :to_none
    when 'to_both'
      status = current_user.id == user[0]  ? :to_second : :to_first
    end
    status
  end

  private

  # validate user2_id > user1_id && requester_id in [user1_id, user2_id]
  def validate_users
    if user2_id <= user1_id
      errors.add(:user2_id, 'user2 id must be greater than user1 id')
    elsif user1_id != requester_id && user2_id != requester_id
      errors.add(:requester_id, 'requester cannot be a third person')
    end
  end
end
