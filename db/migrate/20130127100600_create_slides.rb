class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :name
      t.string :art
      t.text :data

      t.integer :item_id
      t.timestamps
    end
  end
end
