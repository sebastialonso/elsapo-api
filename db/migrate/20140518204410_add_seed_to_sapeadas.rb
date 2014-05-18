class AddSeedToSapeadas < ActiveRecord::Migration
  def change
    add_column :sapeadas, :seed, :boolean
  end
end
