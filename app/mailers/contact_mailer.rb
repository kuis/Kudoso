class ContactMailer < ApplicationMailer
  def contactus_email(contact, msg)
    @contact = contact
    @message = msg
    mail(to: @contact.primary_email, subject: 'Message from Contact Us Form')
  end
end
