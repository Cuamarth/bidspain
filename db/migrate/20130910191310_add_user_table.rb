class AddUserTable < ActiveRecord::Migration
  def change
     create_table :users do |u|      
       u.string :username
       u.string :password
       u.string :lastname
       u.string :name
       u.string :mail
       u.string :address
       u.string :zipcode
       u.string :city
       u.string :sex
       u.string :state
       u.string :country       
       u.decimal :money
       u.integer :freebids
       u.integer :halfbids
       u.datetime :lastlogindate
       u.boolean :banned
       u.timestamps

         
       
     end

  end
end
