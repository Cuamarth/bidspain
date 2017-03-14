class CreateHistoricalbidUsersJoinTable < ActiveRecord::Migration
  def change
      create_table :historicalbets do |h|      
        h.integer :historicalbid_id
        h.integer :user_id        
        h.integer :position
        h.timestamp
      end
  
  end
end
