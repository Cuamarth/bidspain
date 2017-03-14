class ChangeBidsUserIdColumnType < ActiveRecord::Migration
  def change
    change_column :bids, :userwiner, :integer
  end

  
end
