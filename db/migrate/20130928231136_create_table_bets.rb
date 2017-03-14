class CreateTableBets < ActiveRecord::Migration
  def change
    create_table :bets do |b|
      b.decimal :quantity, precision: 10, scale: 2
      b.integer :user_id
      b.integer :bid_id
      b.string :status     
      b.timestamps
 
    end
  end
end
