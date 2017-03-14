ActiveAdmin.register Payorder,:as => "Pago" do
   menu :label => "Pagos"
  actions :all, :except => [:new,:show,:edit,:delete]
  
   
   
   #Filters   
   filter :user,:label =>"Usuario"
   filter :money, :label =>"Cantidad"
   filter :paytype, :as => :select, :collection => Payorder.paytypes,:label =>"Tipo de Pago"
   filter :status, :as => :select, :collection => Payorder.statusTypes,:label =>"Estado"
   filter :updated_at, :label =>"Fecha"
   
   #Index
    index do
     selectable_column
     column "ID", :id
     column "Usuario", :user do |p|
       if p.user==nil then "" else  p.user.username  end 
     end
     column "Cantidad", :money do |p|
        number_to_currency(p.money)
     end
     column "Tipo de pago", :paytype do |p|
       p.paytype
        
     end
     column "Estado", :status do |p|
       if p.status==0 then "No completada" elsif p.status==1 then "Correctamente pagada " elsif p.status==2 then "Fallada" elsif p.status==1 then "Intento de ataque" end
                 
     end
    column "Fecha", :status do |p|
       p.updated_at.to_formatted_s(:short)   
     end
  
      
    
   end

end
