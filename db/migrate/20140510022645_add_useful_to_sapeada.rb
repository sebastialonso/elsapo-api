class AddUsefulToSapeada < ActiveRecord::Migration
  def change
    add_column :sapeadas, :useful, :boolean
    add_column :buses, :stops , :text
  end
end
