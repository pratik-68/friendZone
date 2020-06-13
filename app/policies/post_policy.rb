# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  # @params {User} user(current_user)
  def index?
    user.is_verified?
  end

  def create?
    user.is_verified?
  end

  def update?
    record.user == user
  end

  def show?
    return true if record.user == user || record.visibility_public?

    if record.visibility_friends?
      users = Friend.user_sequence(record.user.id, user.id)
      return Friend.exists?(
        user1_id: users[0],
        user2_id: users[1],
        status: :accepted
      )
    end

    PostUser.exists?(post: record, user: user) if record.visibility_custom?
  end

  def friend_posts?
    user.is_verified?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
