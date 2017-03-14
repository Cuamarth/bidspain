ActiveAdmin.register Order,:as => "Orden" do
   menu :label => "Ordenes de envio"
   actions :all, :except => [:new,:show]
     
   #Filters   
   filter :product, :label =>"Producto"
   filter :user,:label =>" Usuario"
   filter :sent, :label =>" Enviado"
   
   #Edit and new Form 
   form do |f|
     f.inputs "Detalles" do
       f.input :sent, :label =>"Enviado"
     end      
     f.actions
   end
   
   #Labels in index 
   index do
       selectable_column
       column "ID", :id 
       column "Producto", :product_id do |o|
          raw "<a href='/admin/productos/#{o.product.id}/edit'>#{o.product.title}</a>"
       end
       column "Usuario", :user_id do |o|
         raw "<a href='/admin/usuarios/#{o.user.id}'>#{o.user.fullName}</a>"
          
       end
       column "Enviado", :sent do |o|
         (if o.sent then "Si"else "No" end)          
       end
  
       actions :label => "actions"
        
      
     end
end
