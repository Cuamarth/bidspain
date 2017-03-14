class AddLocalizationToProduct < ActiveRecord::Migration
  def change
     add_column :products,  :english_title, :string
     add_column :products,  :english_description, :text
  end
end
