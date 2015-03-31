class ContactsController < ApplicationController
  respond_to :html


  def create
    @primary_email = params[:contact].try(:[], :emails_attributes).try(:[], 0).try(:[],:address)
    if @primary_email.blank? || params[:contact][:first_name].blank?|| params[:contact][:last_name].blank?
      redirect_to pre_signup_path, alert: 'All information is required!'
    else
      params[:contact].delete(:emails_attributes)
      @email = Email.find_or_create_by(@primary_email)
      @contact = @email.try(:contact)
      @contact ||= Email.contact.create(contact_params)
      if @contact.save
        redirect_to pre_signup_thank_you_path, notice: 'Information was successfully received!'
      else
        redirect_to pre_signup_path, alert: @contact.errors.full_messages.to_sentence
      end
    end


  end


  private


    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :company, :primary_email_id, :address1, :address2, :city, :state, :zip, :address_type_id, :phone, :phone_type_id, :last_contact, :do_not_call, :do_not_email, :contact_type_id, emails_attributes: [ :address ])
    end
end
