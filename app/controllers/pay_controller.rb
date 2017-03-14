class PaysController < ApplicationController
  
  

  
  def verifyPaypal
    id=params[:invoice]
    paypal_id=params[:txn_id]
    status=params[:payment_status]
    ammount=params[:mc_gross]
    Rails.logger.info("Ammount received :"+ammount.to_i.to_s)   
    payOrder=Payorder.find(id)
    Rails.logger.info("Receiving PAYPAL  IPN")
    Rails.logger.info("Validating paypal")
    if (payOrder!=nil and payOrder.status==0 and  (status=="Pending" or status=="Completed") and payOrder.money==ammount.to_i)
      Rails.logger.info("First validation OK")
      Rails.logger.info("Starting second validation ")
        
      uri = URI.parse("https://www.paypal.com/cgi-bin/webscr")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      params[:cmd]="_notify-validate"
      request.set_form_data(params)      
      
      Rails.logger.info("Invocando paypal IPN ")
      response = http.request(request)
      Rails.logger.info("Leyendo respuesta:"+response.body)
      if (response.body=="VERIFIED") then
        Rails.logger.info("Respuesta OK,actualizando monedero")
        payOrder.status=1;
        payOrder.paypal_transaction_id=paypal_id;
        payOrder.save
      end

    
    else
      Rails.logger.info("First validation NOK")      
    end
    
    render :nothing => true
  end
  

  
  def verifyCard
    id=params[:Num_operacion]
    sign=params[:Firma]
    money=params[:Importe]
    ref=params[:Referencia]
    

    
    
    
    
    payOrder=Payorder.find(id)
    Rails.logger.info("Receiving CECA  IPN con referencia"+ref)
    Rails.logger.info("Validating ceca")
    @response="NOT OK"
    if (payOrder!=nil) then 
       payOrder.ref=ref
       Rails.logger.info("First validation OK")
       Rails.logger.info("Firma recibida de ceca :"+sign)
       signGenerated=payOrder.creatececavalidatesign
       
       Rails.logger.info("Firma generada en aplicacion :"+signGenerated)
       
       if( payOrder.status==0 and  sign==signGenerated ) then
          Rails.logger.info("Second validation OK")
          Rails.logger.info("Actualizando monedero")
          payOrder.status=1;
          payOrder.card_transaction_id=ref;
          payOrder.save   
          @response="$*$OKY$*$"

       end
    end
    
    respond_to do |format|
         format.html {render :layout => false}            
    end 
  end
  
end
