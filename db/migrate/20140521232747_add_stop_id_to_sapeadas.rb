class AddStopIdToSapeadas < ActiveRecord::Migration
  def change
    add_column :sapeadas, :stop_id, :integer
  end
end
