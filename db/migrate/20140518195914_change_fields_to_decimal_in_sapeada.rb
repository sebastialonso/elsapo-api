class ChangeFieldsToDecimalInSapeada < ActiveRecord::Migration
  def change
    change_column :sapeadas, :latitude, :decimal, :precision => 7, :scale => 5
    change_column :sapeadas, :longitude, :decimal, :precision => 7, :scale => 5
  end
end
