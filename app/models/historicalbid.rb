class Historicalbid < ActiveRecord::Base  
  attr_protected  
  has_many :historicalbets,:dependent => :delete_all



  def setMainHistoricalBets(bid)
    mainbets=bid.bets.page(1).per(20).order('status ASC,quantity DESC,created_at ASC')
    addedBets = Array.new

    mainbets.each_with_index do |bet,i|
      
      
      if (!(addedBets.include? bet.user.id)) then
        
        histoBet=Historicalbet.new
        histoBet.historicalbid=self
        histoBet.user=bet.user
        histoBet.position=(i+1)
        histoBet.save
        addedBets << bet.user.id
      end
      
      
    end
    
  end

end