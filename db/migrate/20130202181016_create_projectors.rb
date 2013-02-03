class CreateProjectors < ActiveRecord::Migration
  def change
    create_table :projectors do |t|
      t.string :name
      t.integer :slide_id

      t.timestamps
    end
  end
end
