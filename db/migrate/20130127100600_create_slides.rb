class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :name
      t.string :art
      t.text :data
      t.string :unique

      t.integer :item_id
      t.timestamps
    end
    add_index :slides, :unique, :unique => true
  end
end
