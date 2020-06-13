# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # @params {User} user(current_user)
  def friend_list?
    user.is_verified?
  end

  def update?
    record == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
