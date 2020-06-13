# frozen_string_literal: true

class LoginToken < ApplicationRecord
  ## ASSOCIATIONS ------------------------------------------
  has_secure_token
  belongs_to :user

  ## VALIDATIONS --------------------------------------------
  validates :token, uniqueness: true

  ## CALLBACKS-----------------------------------------------
  before_save :set_last_used_on

  private

  def set_last_used_on
    self.last_used_on = Time.current
  end
end
