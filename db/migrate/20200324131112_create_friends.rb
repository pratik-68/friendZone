# frozen_string_literal: true

class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.references :user1, foreign_key: { to_table: 'users' }
      t.references :user2, foreign_key: { to_table: 'users' }
      t.references :requester, foreign_key: { to_table: 'users' }
      t.string :verification_token, null: false
      t.datetime :verification_sent_at
      t.integer :status, null: false, default: 0
      t.datetime :accepted_at
      t.integer :notifications, null: false, default: 0
    end
  end
end
