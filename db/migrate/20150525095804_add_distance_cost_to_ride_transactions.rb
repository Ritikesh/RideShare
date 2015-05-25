class AddDistanceCostToRideTransactions < ActiveRecord::Migration
  def change
  	add_column :ride_transactions, :distance, :float
  	add_column :ride_transactions, :cost, :float
  end
end
