ActiveAdmin.register Offercode,:as => "Codigo" do
     menu :label => "Codigos"
     
    
   #Labels in index 
   index do
     selectable_column
     column "ID",:id
     column "Codigo",:code
     column "Pujas gratis",:freebids     
     column "Pujas a mitad de precio ",:halfbids
     column "Saldo", :moneyQuantity do |c|
       number_to_currency(c.moneyQuantity)
     end    
     column "Comienza", :startdate do |c|
       c.startdate.to_formatted_s(:short)
     end     
     column "Acaba", :enddate do |c|  
       c.enddate.to_formatted_s(:short)
     end
     column "Limite" do |c|
        if c.limit==0 then "Ilimitado" else c.limit end
     end        
     column "Usado " do |c|
        c.offeruses.size
     end        

     actions :label => "actions"     
    
   end 
    #Filters   
   filter :code, :label =>" por codigo"
   filter :startdate, :as => :date_range,:label =>" Buscar por fecha de inicio"
   filter :enddate, :as => :date_range,:label =>" Buscar por fecha de fin"



   #Edit and new Form 
   form do |f|
     f.inputs "Detalles" do
       f.input :code, :label =>"Codigo"
       f.input :freebids  , :label =>"Pujas gratis"
       f.input :halfbids,:label =>"Pujas a mitad de precio "
       f.input :moneyQuantity, :label =>"Saldo"
       f.input :limit, :label =>"LImite de usos (0 significa infinito)"
       f.input :startdate,:as => :date,:label => "Fecha de inicio"
       f.input :enddate,:as => :date, :label =>"Fecha de fin"


     end      
      f.actions
   end


   # Show scren
    show do |c|
      attributes_table do
        row :id
        row('Codigo') {c.code}
        row('Pujas gratis') {c.freebids}
        row("Pujas a mitad de precio ") {c.halfbids}
        row("Limite ") {if c.limit==0 then "Ilimitado" else c.limit end}
        row("Saldo") {c.moneyQuantity}
        row("Comienza") {c.startdate}
        row("Acaba") {c.enddate}
                
      end
      active_admin_comments
    end
  
end
