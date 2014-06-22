class AddMultipliedToSapeada < ActiveRecord::Migration
  def change
    add_column :sapeadas, :multiplied, :boolean, default: false
  end
end
