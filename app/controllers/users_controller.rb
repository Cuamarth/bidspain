class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :authorize
  skip_before_filter :authorize, only: [:registerpost, :register,:remind_password,:remind_password_post]

  def index
    @User =current_user   
    @selectedSection="index" 
    @provincias =Provincia.all.collect{ |p| [p.nombre, p.nombre] }

  end

  def updateUser
    @User = current_user
    @selectedSection="index" 
    @provincias =Provincia.all.collect{ |p| [p.nombre, p.nombre] }

    if (params[:user][:money] or params[:user][:freebids] or params[:user][:halfbids] or params[:user][:banned]) then
        redirect_to :root 
    else
      respond_to do |format|
        if @User.update_attributes(params[:user])
           flash[:notice]= 'Usuario actualizado correctamente'
           format.html { render action: 'index'}
        else
           format.html { render action: 'index' }
        end 
      end
    end
  end
  
  def register
    if (current_user!=nil) then
        redirect_to :root
    else           
       @User = User.new
       @provincias =Provincia.all.collect{ |p| [p.nombre, p.nombre] }
       
    end 
  end
  
  def registerpost
    @User=User.new(params[:user])
    @User.validatePassword=true
    @User.oldPassword=@User.newPassword
    @User.freebids=0
    @User.halfbids=0
    @User.money=0
    @User.validateTerms=true
    @provincias =Provincia.all.collect{ |p| [p.nombre, p.nombre] }
    
    if @User.save then    
       UserMailer.new_user(@User).deliver
       session[:user_id] = @User.id
       redirect_to action: "welcomeuser"
    else
       respond_to do |format|
          format.html { render action: 'register' }
      end
    end 
  end
    
    
  
  def password    
    @User =current_user   
    @selectedSection="password" 
  end
  
  def changepassword    
    @User = current_user
    @User.validatePassword=true
    @selectedSection="password" 
    if (params[:user][:money] or params[:user][:freebids] or params[:user][:halfbids] or params[:user][:banned]) then
        redirect_to :root 
    else
        respond_to do |format|
          if @User.update_attributes(params[:user])
             flash[:notice]= 'Usuario actualizado correctamente'
             format.html { render action: 'password' }
          else
             format.html { render action: 'password' }
          end 
       end
    end  
  end
  
  def bids
    @User = current_user    
    @selectedSection="bids"
    @pendingPayBids=Bid.find :all,:conditions => ["closed =?  and userwiner=?", "1",@User.id ],:order => 'updated_at'
    @historyBets=@User.historicalbets
    
  end
  
  def pay_bid
    @User = current_user
    @Bid = Bid.find(params[:id])
    if (@User.id!=@Bid.userwiner ) then 
        redirect_to :root 
    else
      respond_to do |format|   
        if @User.money>@Bid.winnerquantity         
               moneyDiff= -@Bid.winnerquantity
               if (@Bid.product.ptype=="Dinero") then 
                moneyDiff= moneyDiff+@Bid.price
               end               
               @User.update_money(moneyDiff)
               @Bid.paybid
               format.json {render json: {:result=>"success",:money =>@User.money,:type => @Bid.product.ptype,:id => @Bid.id,:msgmoney => (I18n.t "bidspain.bids.paycorrectmoneyaddedtowallet"),
                 :msgprize => (I18n.t "bidspain.bids.paycorrectchoosepize"),:msgrequestproduct => (I18n.t "bidspain.bids.requestproduct"),:msgrequestcredits => (I18n.t "bidspain.bids.requestbidspaincredits"),:msgpayed => (I18n.t "bidspain.common.payed")}}  
        else
               format.json {render json: {:result=>"failure",:msgerror => simple_format(I18n.t "bidspain.bids.paynotcorrectnotenoughwallet") }}    
        end
      end
    end
  end
  def confirmbid
    @User = current_user
    @Bid = Bid.find(params[:id])
    if (@User.id!=@Bid.userwiner  and @Bid.paid==false) then 
        redirect_to :root 
    else
      respond_to do |format|   
        if (params[:type]=="money" or params[:type]=="product")
              
               if (params[:type]=="money")
                  moneyDiff= @Bid.price
                  @User.update_money(moneyDiff) 
                  @Bid.update_column("userconfirmed",true) 
               else
                  @Bid.update_column("userconfirmed",true)
                  order=Order.new
                  order.product=@Bid.product
                  order.user=@User
                  order.save               
               end  
               format.json {render json: {:result=>"success",:money =>@User.money,:type => params[:type],:msgmoney => (I18n.t "bidspain.bids.paycorrectmoneyaddedtowallet"),
                 :msgproduct => simple_format(I18n.t "bidspain.bids.paycorrectchooseproduct"),:msgpayed => (I18n.t "bidspain.common.payed")}}  
        else
               format.json {render json: {:result=>"failure" }}    
        end
      end
    end
  end 
  
  def wallet
    @User = current_user
    @PayOrder=Payorder.new
    @selectedSection="wallet"
    
  end
  
  def charged
    @User = current_user
    payOrders=Payorder.find :all,:conditions => ["status =?  and user_id=? and updated_at>?", "1",@User.id,1.hour.ago ],:order => 'updated_at'
    
    if payOrders.any? then
      @PayOrder=payOrders[0]
    else
       redirect_to action: "wallet"
    end
  end
  
  def welcomeuser
    @User = current_user
   
    
    unless @User.created_at > 5.minutes.ago then
       redirect_to action: "index"
    end
    
  end
  
  def confirmPay
    @User = current_user    
    @PayOrder=Payorder.new(params[:payorder])
    @PayOrder.user=@User
    @PayOrder.status=0
    
    respond_to do |format|
      if (@PayOrder.save)
          @url= @PayOrder.paypal_url
          
          format.js
      else      
        @errors=@PayOrder.errors
        format.js
      end
    
    end
        
  end

  def codes
    @User = current_user
    @selectedSection="codes"
  end
  
  def usecode
    @User = current_user
    @offerCode=Offercode.find_by_code(params[:codeValue])
    @offerUse=Offeruse.new    
    @offerUse.offercode=@offerCode
    @offerUse.user=@User
    @offerUse.ipuse=request.remote_ip
    respond_to do |format|   
      if @offerUse.save
        format.js
      else
        @errors=@offerUse.errors
        format.js
      end
        
    end
  end
  
  def remind_password
    if (current_user!=nil) then
        redirect_to :root
    end                   
  end
  
  def remind_password_post
   user=User.find :first,:conditions => ["username =?  or mail=? ", params[:remindText],params[:remindText] ]
     respond_to do |format|
      if(user!=nil) then
        @success=true
        user.generate_new_password
        UserMailer.remind_password(user).deliver  
      else
        @error=true
      end 
      format.html { render action: 'remind_password' }

    end
  end
end
