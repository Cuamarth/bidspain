class BetValidator < ActiveModel::Validator
    def validate(record)
      
        record.errors[:bet_error] << "bidspain.bids.bettoomuch" if record.quantity >record.bid.maxbid
        record.errors[:bet_error] << "bidspain.bids.bettoolow" if record.quantity <=0
        record.errors[:bet_error] << "bidspain.bids.betoutofdate" if record.bid.endingTime <Time.now
        record.errors[:bet_error] << "bidspain.bids.alreadydiqualified" if ((Bet.find :all,:conditions => ["quantity =? AND bid_id=?", record.quantity,record.bid_id ]).size>2)
        record.errors[:bet_error] << "bidspain.bids.isclosed" if (!record.bid.active or record.bid.closed)
        record.errors[:bet_error] << "bidspain.bids.nomorebetsallowed" if (record.bid.nbids >record.bid.nbids_max and record.bid.endingTime <Time.now)
        record.errors[:bet_error] << "bidspain.bids.nofreebidsleft" if (record.freebid=="true" and record.user.freebids<1)
        record.errors[:bet_error] << "bidspain.bids.nohalfbidsleft" if (record.halfbid=="true" and record.user.halfbids<1)   
        
        multiplicator=1 
        multiplicator=0.5 if record.halfbid=="true"       
        multiplicator=0 if record.freebid=="true"           
              
        record.errors[:bet_error] << "noenoughmoney" if (record.user.money<record.bid.cost_per_bid*multiplicator)
        
        
         
      
    end
end


class BidValidator < ActiveModel::Validator
    def validate(record)
        
        if (record.active and (record.place==nil or record.place <=0)) then 
          record.errors[:place] << "Si la puja esta activa necesita un lugar "
        else        
          bid=Bid.find_by_place_and_active(record.place,true)
          if (record.id!=nil) then           
            oldBid=Bid.find(record.id);
  
            if (record.active and  bid!=nil and !(oldBid!=nil and oldBid.id==bid.id) ) then 
              record.errors[:place] << "El lugar ya esta reservado por otra puja activa "
            end
          end
        end
    
    end
end

class UserValidator < ActiveModel::Validator
    def validate(record)
        
        if (record.validatePassword) then
          record.errors[:oldPassword] << "bidspain.user.passworderror" if (record.id!=nil and (record.oldPassword=="" or  !record.authenticate(record.oldPassword)))
          record.errors[:confirmPassword] << "bidspain.user.confirmpassworderror" if !(record.confirmPassword==record.newPassword)
          record.errors[:newPassword] << "bidspain.user.passwordpolicy" if !(/^(?=.*\d).{6,12}$/.match(record.newPassword))
        end
        if (record.validateTerms) then 
          record.errors[:terms_of_service] << "bidspain.user.mustaccepttermsofservice" if record.terms_of_service==nil
          record.errors[:older_enough] << "bidspain.user.olderthan18error" if record.older_enough==nil
        end
    end
end

class OfferuseValidator < ActiveModel::Validator
    def validate(record)
        if (record.offercode==nil) then       
          record.errors[:code] << "bidspain.user.offercodenotexists"
        else
          offeruse=Offeruse.find_by_user_id_and_offercode_id(record.user.id,record.offercode.id)
          offerSameIp=Offeruse.find_by_ipuse(record.ipuse)  
          
          record.errors[:code] << "bidspain.user.offercodealreadyused" if (offeruse!=nil)
          record.errors[:code] << "bidspain.user.offercodeexpired" if (Time.now >record.offercode.enddate)
          record.errors[:code] << "bidspain.user.offercodenotready" if (Time.now <record.offercode.startdate)
          record.errors[:code] << "bidspain.user.offercodemanytimes" if (record.offercode.limit!=0 and record.offercode.limit!=nil and record.offercode.offeruses.size>=record.offercode.limit)
        end       
          
 
    
    end
end

