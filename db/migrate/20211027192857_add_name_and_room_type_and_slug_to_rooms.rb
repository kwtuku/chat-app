class AddNameAndRoomTypeAndSlugToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :name, :string
    add_column :rooms, :slug, :string
    add_column :rooms, :room_type, :integer
    add_index :rooms, :slug, unique: true
  end
end
