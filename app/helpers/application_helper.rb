module ApplicationHelper
  
  def has_pending_bids
    @pendingPayBids=Bid.find :all,:conditions => ["closed =?  and userwiner=? and paid=?", "1",@User.id,"0" ],:order => 'updated_at'
    return @pendingPayBids.any?
  end
  
  def has_desktop_preference
    if (cookies[:preferencedesktop]!=nil and cookies[:preferencedesktop]=="true")
      return true
    else
      return false
    end  
    
    
  end
  
end
