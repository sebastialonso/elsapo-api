class AddCentroidsToBus < ActiveRecord::Migration
  def change
    add_column :buses, :centroids, :text
  end
end
