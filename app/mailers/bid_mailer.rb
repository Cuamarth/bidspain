class BidMailer < ActionMailer::Base
  default from: "no-reply@bidspain.com"
  
  
  def bid_won(user,bid)
    @user = user
    @bid =bid
    @url  = 'http://www.bidspain.com/user/bids'
    mail(to: @user.mail, subject: 'Subasta Ganada!')
  end
  
end
