class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.string :name
      t.integer :position
      t.boolean :finished
      t.string :ancestry

      t.timestamps
    end
  end
end
