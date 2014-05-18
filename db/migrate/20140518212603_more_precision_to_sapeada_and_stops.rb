class MorePrecisionToSapeadaAndStops < ActiveRecord::Migration
  def change
    change_column :sapeadas, :latitude, :decimal, :precision => 8, :scale => 6
    change_column :sapeadas, :longitude, :decimal, :precision => 8, :scale => 6
    change_column :stops, :latitude, :decimal, :precision => 8, :scale => 6
    change_column :stops, :longitude, :decimal, :precision => 8, :scale => 6
  end
end
