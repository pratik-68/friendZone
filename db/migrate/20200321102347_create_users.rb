class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false, limit: 20
      t.string :last_name, null: false, limit: 20
      t.integer :gender, null: false    # 0 => Male, 1 => Female, 2 => others
      t.date :date_of_birth, null: false
      t.string :city, limit: 20
      t.text :interests

      ## Database authenticatable
      t.string :email, null: false
      t.string :username, null: false, limit: 20
      t.string :password_digest, null: false

      ## For Verification
      t.string :email_verification_token, null: false
      t.boolean :is_verified, null: false, default: 0

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      t.datetime :last_login_at
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
