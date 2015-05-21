class ContactsController < ApplicationController


  def create
    @primary_email = params[:contact].try(:[], :emails_attributes).try(:[], "0").try(:[],:address)
    if @primary_email.blank?
      respond_to do |format|
        format.html { redirect_to pre_signup_path, alert: 'All information is required!' }
        format.json { render :nothing => true, :status => 400 }
      end

    else
      params[:contact].delete(:emails_attributes)

      agile_contact = AgileCRMWrapper::Contact.search_by_email(@primary_email)
      @email = Email.find_by(address: @primary_email)
      if @email
        if agile_contact
          agile_contact.update(tags: ["newsletter"])
        end
        respond_to do |format|
          format.html { redirect_to pre_signup_path, alert: 'Sorry, you are already signed up!' }
          format.json { render json: { error: 'Sorry, this email address is already registered.'}, :status => 409 }
        end
      else
        begin
          agile_contact = AgileCRMWrapper::Contact.create( tags: [ "newsletter" ], email: @primary_email )
        rescue AgileCRMWrapper::BadRequest
          logger.debug "AgileCRMWrapper: BadRequest for email: #{@primary_email}"
        end

        @email = Email.create(address: @primary_email)
        @contact = @email.try(:contact)
        if @contact.nil?
          @contact = Contact.create( contact_params )
          @email.contact_id = @contact.id
          @email.save
        end
        if @contact.save
          respond_to do |format|
            format.html { redirect_to pre_signup_thank_you_path, notice: 'Information was successfully received!' }
            format.json { render json: {}, :status => 200 }
          end

        else
          logger.info  @contact.errors.full_messages.to_sentence
          respond_to do |format|
            format.html { redirect_to pre_signup_path, alert: @contact.errors.full_messages.to_sentence }
            format.json { render json:  {error: @contact.errors.full_messages }, :status => 500 }
          end
        end
      end


    end


  end


  private


    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :company, :primary_email_id, :address1, :address2, :city, :state, :zip, :address_type_id, :phone, :phone_type_id, :last_contact, :do_not_call, :do_not_email, :contact_type_id, emails_attributes: [ :address ])
    end
end
