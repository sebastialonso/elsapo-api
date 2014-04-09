class CreateSapeadas < ActiveRecord::Migration
  def change
    create_table :sapeadas do |t|
      t.integer :bus_id, :null => false
      t.decimal :latitude, :null => false
      t.decimal :longitude, :null => false
      t.integer :week_day, :null => false
      t.integer :catch_time, :null => false

      t.timestamps
    end
  end
end
