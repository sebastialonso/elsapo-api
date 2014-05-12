class ChangeNameOfStopsColumn < ActiveRecord::Migration
  def change
    rename_column :buses, :stops, :paradas
  end
end
