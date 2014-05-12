class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :direction

      t.timestamps
    end
  end
end
