class AddStopIdToCentroid < ActiveRecord::Migration
  def change
    add_column :centroids, :stop_id, :integer
  end
end
