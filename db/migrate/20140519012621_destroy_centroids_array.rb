class DestroyCentroidsArray < ActiveRecord::Migration
  def change
    remove_column :buses, :centroids
  end
end
