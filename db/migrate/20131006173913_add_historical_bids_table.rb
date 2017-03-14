class AddHistoricalBidsTable < ActiveRecord::Migration
  def change
      create_table :historicalbids do |b|      
        b.integer :product_id      
        b.integer :userwiner
        b.integer :winnerquantity
        b.integer :nbids
        b.timestamp :endingTime
        b.timestamps
      end
  
  end

end