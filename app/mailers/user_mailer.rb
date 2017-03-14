class UserMailer < ActionMailer::Base
  default from: "no-reply@bidspain.com"
  
  def new_user(user)
    @user = user
    @url  = 'http://www.bidspain.com/user'
    mail(to: @user.mail, subject: 'Nueva cuenta creada en bidspain.com')
  end
  
  def remind_password(user)
    @user =user
    mail(to: @user.mail, subject: 'Nueva clave de acceso generada para bidspain.com')
  end
end
