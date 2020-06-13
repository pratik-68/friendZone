# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.integer :visible_to, null: false 
      t.text :description
      t.timestamps
    end
  end
end
