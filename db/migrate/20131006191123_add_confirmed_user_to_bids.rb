class AddConfirmedUserToBids < ActiveRecord::Migration
  def change
     add_column :bids,  :userconfirmed, :boolean

  end
end
