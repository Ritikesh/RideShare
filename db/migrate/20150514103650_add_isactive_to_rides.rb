class AddIsactiveToRides < ActiveRecord::Migration
  def change
  	add_column :rides, :isactive, :boolean, default: true
  end
end
