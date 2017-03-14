class CreatePayOrderTable < ActiveRecord::Migration
  def change
      create_table :pay_orders do |b|      
        b.integer :money      
        b.integer :user_id
        b.string  :paytype
        b.integer :status
        b.string :paypal_transaction_id
        b.string :card_transaction_id
        b.timestamps
      end
  
  end
end
