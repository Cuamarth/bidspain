ActiveAdmin.register Bid, :as => "Subasta" do
   menu :label => "Subastas"
  #Remove show action 
   actions :all, :except => [:show]
  
   #Edit and new Form 
   form  :partial => 'bid_form'      
   
          
   #Filters
   filter :product ,:label =>" por producto"
   filter :nbids ,:label =>" por pujas realizadas"
   filter :place ,:label =>" por lugar"
   filter :endingTime, :label => " por fecha de fin"
   filter :active, :label => "activa"
   filter :autorenewal, :label => "autorenovable"
   filter :closed, :label => "cerrada"
   
   
   #Labels in index 
   index do
     selectable_column
     column "Imagen", :image_url do |b|
        link_to image_tag(b.product.image_url(:thumb),alt: b.product.title),b.product.image_url.url ,class: 'fancyImage img_thumbnail'
     end
     column "Producto", :title do |b|
        raw ""+(link_to b.product.title+" (#{number_to_currency(b.price)})","#data-desc-id#{b.product.id.to_s}",class: 'fancyText')+""+ 
           "<div style='display:none'><div id='data-desc-id#{b.product.id.to_s}'><strong>#{b.product.title}</strong>#{simple_format(b.product.description)}</div></div>"

     end
     column "Lugar", :place
     column "Precio Max", :nbids_max do |b|
       raw number_to_currency(b.maxbid) +" (#{number_to_currency(b.cost_per_bid)} por puja)"
     end
     column "Pujas", :nbids_max do |b|
       raw b.nbids_max.to_s+" (Quedan #{b.nbids_max-b.nbids})"
     end
     column "Activa", :active do |b|
       raw (if b.active? then 'Si'else 'No' end)
     end

     column "Fecha de fin", :endingTime do |b|
       if b.endingTime? then b.endingTime.to_formatted_s(:short) end 
     end
     column "Cerrada", :closed do |b|
       raw (if b.closed? then 'Si'else 'No' end) 
     end
     column "Finalizable", :userconfirmed do |b|
       raw (if (b.closed and b.paid ) then 'Si'else 'No' end) 
     end    
     column "Dinero ganado",:nbids_max do |b|
       number_to_currency(b.getEarnedMoney)
     end  
     actions :label => "actions"
      
    
   end
   
    member_action :finalizar, :method => :get do
      bid = Bid.find(params[:id])      
      historicalbid=Historicalbid.new
      historicalbid.product_name=bid.product.title
      historicalbid.small_image_url=bid.product.image_url(:thumb)
      historicalbid.medium_image_url=bid.product.image_url(:mainprincipal)
      historicalbid.nbids=historicalbid.nbids
      historicalbid.endingTime=bid.endingTime
      historicalbid.userwiner=bid.userwiner
      historicalbid.winnerquantity=bid.winnerquantity
      historicalbid.earnedmoney=bid.getEarnedMoney+bid.winnerquantity
      historicalbid.save      
      
      historicalbid.setMainHistoricalBets(bid)
      
      bid.destroy
      
      redirect_to :action => :index, :notice => "Puja Finalizada"
    end
       
end
