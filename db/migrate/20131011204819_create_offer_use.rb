class CreateOfferUse < ActiveRecord::Migration
  def up
      create_table :offer_uses do |o|      
        o.integer :user_id
        o.integer :offercode_id
        o.string :ipuse
        o.timestamps
      end
  
  end
  def down 
    drop_table :offer_uses
  end
end
