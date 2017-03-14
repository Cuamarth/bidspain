class AddRealQuantityToBet < ActiveRecord::Migration
  def change
     add_column :bets,  :realpaid, :float,precision: 5, scale: 2
     add_column :historicalbids,  :earnedmoney, :float,precision: 5, scale: 2

  end
end
