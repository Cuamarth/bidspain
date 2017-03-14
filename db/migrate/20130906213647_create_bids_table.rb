class CreateBidsTable < ActiveRecord::Migration
  def change
    create_table :bids do |b|      
      b.integer :product_id      
      b.decimal :price, precision: 5, scale: 2
      b.integer :place
      b.integer :nbids_max
      b.integer :nbids
      b.decimal :maxbid
      b.decimal :cost_per_bid , precision: 4, scale: 2
      b.timestamp :endingTime
      b.time :firstBidTime 
      b.time :renewalTime 
      b.boolean :active
      b.boolean :autorenewal     
      b.timestamps
    end
  end
end
