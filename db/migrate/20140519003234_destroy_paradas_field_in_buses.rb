class DestroyParadasFieldInBuses < ActiveRecord::Migration
  def change
    remove_column :buses, :paradas
  end
end
