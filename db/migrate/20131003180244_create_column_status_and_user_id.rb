class CreateColumnStatusAndUserId < ActiveRecord::Migration
  def change
     add_column :bids,  :userwiner, :numeric
     add_column :bids,  :closed, :boolean
     add_column :bids,  :paid, :boolean
  end

end
