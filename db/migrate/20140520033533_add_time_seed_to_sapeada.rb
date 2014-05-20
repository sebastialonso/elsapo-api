class AddTimeSeedToSapeada < ActiveRecord::Migration
  def change
    add_column :sapeadas, :timeseed, :boolean
  end
end
