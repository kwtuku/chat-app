class CreateHellos < ActiveRecord::Migration[6.0]
  def change
    create_table :hellos do |t|
      t.text :hello
      t.text :content

      t.timestamps
    end
  end
end
