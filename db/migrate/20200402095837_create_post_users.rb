class CreatePostUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :post_users do |t|
      t.timestamps
    end
    add_reference :post_users, :user, foreign_key: true
    add_reference :post_users, :post, foreign_key: true
    add_index :post_users, %i[user_id post_id], unique: true
  end
end
