class AddPayedQuantityToBids < ActiveRecord::Migration
  def change
     add_column :bids,  :winnerquantity, :decimal, precision: 10, scale: 2

  end
end
