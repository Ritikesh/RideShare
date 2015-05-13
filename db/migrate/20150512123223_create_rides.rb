class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :from_address
      t.float :from_latitude
      t.float :from_longitude
      t.string :to_address
      t.float :to_latitude
      t.float :to_longitude
      t.datetime :timeofride
      t.string :car_description
      t.integer :seats_available

      t.timestamps null: false
    end
  end
end
