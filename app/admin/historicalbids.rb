ActiveAdmin.register Historicalbid do
     menu :label => "Historico de Subastas"
     actions :all, :except => [:edit,:new,:show]
     
      #Filters
     filter :nbids ,:label =>" por pujas realizadas"
     filter :endingTime, :label => " por fecha de fin"
     
     #Labels in index 
     index do
       selectable_column
       column "Imagen", :image_url do |b|
          link_to image_tag(b.small_image_url,alt: b.product_name),b.small_image_url ,class: 'fancyImage img_thumbnail'
       end

       column "Ganador", :userwiner do |b|
         raw (if (b.userwiner!=0) then User.find(b.userwiner).fullName else "" end)
       end
       column "Pujas", :nbids do |b|
         raw b.nbids.to_s
       end
       column "Puja mas alta", :winnerquantity do |b|
         raw number_to_currency(b.winnerquantity.to_s)
       end

       column "Fecha de fin", :endingTime do |b|
         if b.endingTime? then b.endingTime.to_formatted_s(:short) end 
       end
       
       column "Dinero ganado", :earnedmoney do |b|
         number_to_currency(b.earnedmoney)
       end
  
       actions :label => "actions"
        
      
     end
end
