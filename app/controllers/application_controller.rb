class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  
  def set_locale
    if params.include?('locale')
      locale=params[:locale]
      if (locale!="es" and locale!="en" ) then
        locale="en"
      end
      I18n.locale = params[:locale]      
      cookies[:locale] = params[:locale]   
    else
      if (cookies[:locale]) then 
        I18n.locale = cookies[:locale]
      else
        I18n.locale = getDefaultLocale
      end
    end   
  end
  
  def getDefaultLocale
    prefferedLocale=request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if (prefferedLocale=="es")
      return "es"
    else
      return "en"
    end
  end
  
  
  protected
    def current_user
      return User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
       return nil
    end
    
    def authorize
      
      if session[:user_id]==nil or !User.find(session[:user_id])  then 
        if (session[:user_id]!=nil and User.find(session[:user_id]) and  current_user.banned) then 
         session[:user_id]=nil
        end        
        redirect_to root_url
      end
    end
    

end
