class UniquenessPerRideTransaction < ActiveRecord::Migration
  def change
  	add_index :ride_transactions, ["user_id", "ride_id"], unique: true
  end
end
