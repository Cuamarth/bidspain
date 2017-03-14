class Place    
  attr_accessor :nplace,:bid_id
  
  public
  def self.get_total_places
    bids=Bid.find(:all)
    places=[]
    
    51.times do |i|
      place=Place.new
      place.bid_id=0
      place.nplace=i
      places[i]=place
    end
    
    bids.each do |bid|
      place=Place.new
      place.bid_id=bid.id
      place.nplace=bid.place
      places[bid.place]=place  
    end 
    
    return places;
    
  end

end
