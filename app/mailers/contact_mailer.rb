class ContactMailer < ApplicationMailer
  def contactus_email(contact, msg)
    @contact = contact
    @message = msg
    mail(to: 'info@kudoso.com', subject: 'Message from Contact Us Form')
  end
end
