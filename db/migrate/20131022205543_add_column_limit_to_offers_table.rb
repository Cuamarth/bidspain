class AddColumnLimitToOffersTable < ActiveRecord::Migration
  def change
     add_column :offer_codes,  :limit, :integer
     add_column :orders,  :sent, :boolean

  end
end
