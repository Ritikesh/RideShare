class Add < ActiveRecord::Migration
  def change
  	add_column :rides, :user_id, :integer
  	add_index :rides, :user_id
  end
end
