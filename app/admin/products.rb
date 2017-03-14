ActiveAdmin.register Product, :as => "Producto" do
   
   #Administration menu label
   menu :label => "Productos"
   
   #Remove show action 
   actions :all, :except => [:show]
       
   #Filters
   filter :title , :as => :string,:label =>" por nombre"
   filter :description , :as => :string,:label =>" por descripcion"
   filter :price, :as => :numeric,:label =>" Buscar por valor "
   filter :ptype, :as => :select, :collection => Product.getTypes,:label => "por tipo"
   filter :updated_at, :as => :date_range,:label =>" BUscar por ultima modificaci&oacute;n "
    

   
   #Labels in index 
   index do
     selectable_column
     column "Imagen", :image_url do |p|
        link_to image_tag(p.image_url.url(:thumb),alt: p.title),p.image_url.url,class: 'fancyImage img_thumbnail'
     end
     column "Tipo",:ptype
     column "Nombre", :title do |p|
       raw '<h4>'+p.title+'</h4><p>'+
           (p.description.length >200 ?  simple_format(p.description[0..200])+(link_to ' Leer mas...',"#data-desc-id#{p.id.to_s}",class: 'fancyText'):simple_format(p.description))+'</p>'+
           "<div style='display:none'><div id='data-desc-id#{p.id.to_s}'>#{simple_format(p.description)}</div></div>"

     end
     column "Valor", :price do |p|
       number_to_currency (p.price)
     end
     column "Ultima modificacion", :updated_at do |p|
       p.updated_at.to_formatted_s(:short)
     end     
     
     actions :label => "actions"
      
    
   end
   

   #Edit and new Form 
   form do |f|
     f.inputs "Detalles" do
       f.input :title, :label => "Nombre"
       f.input :english_title, :label => "Nombre Ingles"
       f.input :ptype, :as => :select, :collection => Product.getTypes,:label => "Tipo"       
       f.input :price, :label => "Valor"
       f.input :image_url, :as => :file,:label => "Imagen" 
       f.input :description,:label => "Descripci&oacute;n",:as => :ckeditor , :input_html => { :ckeditor => {  :toolbar => "mini", :height => "600px" } }
       f.input :english_description,:label => "Descripci&oacute;n Ingles",:as => :ckeditor , :input_html => { :ckeditor => {  :toolbar => "mini", :height => "600px" } }
     end      
      f.actions
   end
   
   #Show form
   show do |ad|   
      attributes_table do  
        row :title, :label => "Nombre"
        row :description, :label => "Descripci&oacute;n"
        row :image_url, :label => "Imagen"
        row :price, :label => "Valor"
      end 
      active_admin_comments
    end
   

   
end

