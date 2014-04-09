class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.string :line_number

      t.timestamps
    end
  end
end
