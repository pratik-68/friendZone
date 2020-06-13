# frozen_string_literal: true

class AddIndexToUserToken < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email_verification_token, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :friends, [:user1_id, :user2_id], unique: true
    add_index :friends, :verification_token, unique: true
  end
end
