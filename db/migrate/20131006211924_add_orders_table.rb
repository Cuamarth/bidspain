class AddOrdersTable < ActiveRecord::Migration
  def change
      create_table :orders do |b|      
        b.integer :product_id      
        b.integer :user_id
        b.timestamps
      end
  
  end
end
