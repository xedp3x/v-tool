class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_sec
      t.text :rights

      t.timestamps
    end
  end
end
