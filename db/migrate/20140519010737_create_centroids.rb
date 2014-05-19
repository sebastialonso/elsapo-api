class CreateCentroids < ActiveRecord::Migration
  def change
    create_table :centroids do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.integer :catch_time
      t.integer :bus_id
      t.boolean :direction

      t.timestamps
    end
  end
end
