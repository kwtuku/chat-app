class DropHellos < ActiveRecord::Migration[6.0]
  def change
    drop_table :hellos do |t|
      t.text :hello
      t.text :content
      t.timestamps null: false
    end
  end
end
