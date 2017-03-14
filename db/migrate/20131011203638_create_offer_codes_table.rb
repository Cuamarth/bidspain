class CreateOfferCodesTable < ActiveRecord::Migration
  def up
      create_table :offer_codes do |o|      
        o.decimal :moneyQuantity
        o.string  :code
        o.integer :freebids        
        o.integer :halfbids
        o.timestamp :startdate
        o.timestamp :enddate
        o.timestamps
      end
  
  end
  def down 
    drop_table :offercodes
  end
end
