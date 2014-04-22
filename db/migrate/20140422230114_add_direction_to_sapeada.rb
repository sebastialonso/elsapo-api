class AddDirectionToSapeada < ActiveRecord::Migration
  def change
    add_column :sapeadas, :direction, :boolean
  end
end
