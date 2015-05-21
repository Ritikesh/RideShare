class AddAddressToTransactions < ActiveRecord::Migration
  def change
  	add_column :ride_transactions, :from_address, :string
  	add_column :ride_transactions, :from_latitude, :float
  	add_column :ride_transactions, :from_longitude, :float
  	add_column :ride_transactions, :to_address, :string
  	add_column :ride_transactions, :to_latitude, :float
  	add_column :ride_transactions, :to_longitude, :float
  	add_column :ride_transactions, :isactive, :boolean, default: true
  end
end
