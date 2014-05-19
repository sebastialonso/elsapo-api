class AddPrecisionToCentroids < ActiveRecord::Migration
  def change
    change_column :centroids, :latitude, :decimal, :precision => 10, :scale => 8
    change_column :centroids, :longitude, :decimal, :precision => 10, :scale => 8
  end
end
