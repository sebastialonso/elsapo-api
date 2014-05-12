class CreateBusesStopsJoinTable < ActiveRecord::Migration
  def change
    create_table :buses_stops, id: false do |t|
      t.integer :bus_id
      t.integer :stop_id
    end
  end
end
