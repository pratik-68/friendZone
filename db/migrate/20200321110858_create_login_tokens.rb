class CreateLoginTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :login_tokens do |t|
      t.string :token, null: false
      t.datetime :last_used_on, null: false
      t.datetime :created_at, null: false
    end
    add_index :login_tokens, :token, unique: true
    add_reference :login_tokens, :user, foreign_key: true
  end
end
