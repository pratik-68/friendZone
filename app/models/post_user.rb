# frozen_string_literal: true

class PostUser < ApplicationRecord
  ## ASSOCIATIONS ------------------------------------------
  belongs_to :user
  belongs_to :post

  ## VALIDATIONS ---------------------------------------------
  validates :user_id, uniqueness: { scope: :post_id }
end
