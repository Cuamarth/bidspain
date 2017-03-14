class Provincia < ActiveRecord::Base
  set_table_name "provincias"
  attr_protected
  
  validates_presence_of :nombre
end
