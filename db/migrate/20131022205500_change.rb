class Change < ActiveRecord::Migration
  def change
    change_column :historicalbids, :winnerquantity, :decimal, precision: 10, scale: 2
  end

  
end
