ActiveAdmin.register User, :as => "Usuario" do 

   #Administration menu label
   menu :label => "Usuarios"
   

       
   #Filters   
   filter :id, :label =>" por ID de usuario"
   filter :username, :label =>" por nombre de usuario"
   filter :mail, :label =>" por email"
   filter :name  , :label =>" por nombre"
   filter :lastname,:label =>" por apellidos "
   filter :address, :label =>" por Direccion "
   filter :zipcode, :label =>" por Codigo postal  "
   filter :city, :label =>" por Ciudad  "
   filter :state,:as => :select, :collection => Provincia.all.collect{ |p| [p.nombre, p.nombre] }, :label =>" por Provincia  "
   filter :sex, :as => :select, :collection => User.getSexTypes,:label =>" por sexo del usuario "
   filter :money, :label =>" por saldo en cuenta "
   filter :freebids, :label =>" con pujas gratis "
   filter :halfbids, :label =>" con pujas a mitad de precio "   
   filter :lastlogindate, :label =>" por fecha de ultimo login"
   filter :banned, :label =>" usuarios  baneados"
   


   #Edit and new Form 
   form do |f|
     f.inputs "Detalles" do
       f.input :username, :label =>" Nombre de usuario"
       f.input :password_hash, :label =>simple_format(' Contrase&ntilde;a')
       f.input :name  , :label =>"Nombre"
       f.input :lastname,:label =>"Apellidos "
       f.input :mail, :label =>"Email", :as => :email
       f.input :sex, :as => :select, :collection => User.getSexTypes,:label => "Sexo"
       f.input :address, :label =>"Direccion "
       f.input :zipcode, :label =>"Codigo postal"
       f.input :city, :label =>"Ciudad "
       f.input :state,:as => :select, :collection => Provincia.all.collect{ |p| [p.nombre, p.nombre] }, :label =>"Provincia"
       f.input :country, :label =>"Pais"
       f.input :money, :label =>"Saldo"
       f.input :freebids, :label =>"Pujas gratis "
       f.input :halfbids, :label =>"Pujas a mitad de precio"
       f.input :banned, :label =>"Usuario baneado"

     end      
      f.actions
   end
   
   #Labels in index 
   index do
     selectable_column
     column "ID",:id
     column "Nombre de usuario",:username
     column "Nombre" do |u|
       u.name+" "+u.lastname   
     end
     column "Email",:mail    
     column "Saldo" do |u| 
       number_to_currency (u.money)
     end
     column "Pujas a 1/2",:halfbids
     column "Pujas gratis",:freebids
     column "Baneado" do  |u|
       if u.banned then "Si" else "No" end
     end
     column "Ultimo login",:lastlogindate do  |u|
       if ( u.lastlogindate!=nil)
        u.lastlogindate.to_formatted_s(:short)
       end       
     end   
     actions :label => "actions"     
    
   end
   
   # Show scren
    show do |u|
      attributes_table do
        row :id
        row(' Nombre de usuario') {u.username}
        row("Nombre") {u.name+" "+u.lastname}        
        row("Email") {u.mail}
        row("Sexo") {u.sex}
        row("Direccion") {u.address}
        row("Codigo postal") {u.zipcode}
        row("Ciudad") {u.city}
        row("Provincia") {u.state}
        row("Pais") {u.country}
        row("Saldo") {u.money}
        row("Ultima fecha de login") {u.lastlogindate}
        row("Pujas gratis") {u.freebids}
        row("Pujas a mitad de precio") {u.halfbids}
        row("Usuario baneado") {if u.banned then "Si" else "No" end}
        
      end
      active_admin_comments
    end
       
       
  
   

end
