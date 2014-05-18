class EvenMorePrecisionToSapeadaAndStops < ActiveRecord::Migration
  def change
    change_column :sapeadas, :latitude, :decimal, :precision => 10, :scale => 8
    change_column :sapeadas, :longitude, :decimal, :precision => 10, :scale => 8
    change_column :stops, :latitude, :decimal, :precision => 10, :scale => 8
    change_column :stops, :longitude, :decimal, :precision => 10, :scale => 8
  end
end
