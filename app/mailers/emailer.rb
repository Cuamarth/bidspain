class Emailer < ActionMailer::Base
  default from: "abenitezsan@gmail.com"
  
   def sample_email(user)
    @user = user
    @url  = 'http://herokuapp.bidspain.com'
    mail(to: @user.mail, subject: 'Welcome to My Awesome Site')
  end
end
