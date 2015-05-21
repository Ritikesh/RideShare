class AddTimeofrideToTransaction < ActiveRecord::Migration
  def change
  	add_column :ride_transactions, :timeofride, :datetime
  end
end
