class AddProductFieldsToHistoricalBids < ActiveRecord::Migration
  def change
     add_column :historicalbids,  :small_image_url, :string
     add_column :historicalbids,  :medium_image_url, :string
     add_column :historicalbids,  :product_name, :string
  end
end
