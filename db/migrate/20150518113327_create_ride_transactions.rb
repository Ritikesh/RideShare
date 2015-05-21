class CreateRideTransactions < ActiveRecord::Migration
  def change
    create_table :ride_transactions do |t|
      t.integer :ride_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_column :rides, :seats_remaining, :integer
  end
end
