class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :position
      t.string :ancestry

      t.timestamps
    end
  end
end
