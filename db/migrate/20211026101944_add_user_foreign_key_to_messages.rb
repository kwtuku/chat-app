class AddUserForeignKeyToMessages < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :messages, :users
    add_index :messages, :user_id
  end
end
