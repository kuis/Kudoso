class ContactsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :index # for JSONP ajax from blog.kudoso.com

  def index
    @primary_email = params[:contact].try(:[], :emails_attributes).try(:[], "0").try(:[],:address)
    @primary_email ||= params[:contact].try(:[], :emails_attributes).try(:[], :"0").try(:[],:address)
    params[:contact].delete(:emails_attributes)
    if @primary_email.blank?
      respond_to do |format|
        render json: {error: 'All information is required'}, :callback => params[:callback], :status => 400
      end
    else
      begin
        agile_contact = AgileCRMWrapper::Contact.search_by_email( @primary_email )
        if @agile_contact.nil?
          agile_contact = AgileCRMWrapper::Contact.create( email: @primary_email,
                                                           first_name: params[:contact][:first_name],
                                                           last_name: params[:contact][:last_name] )
        else
          if params[:contact] &&  params[:contact][:first_name] && params[:contact][:last_name]
            agile_contact.update(first_name: params[:contact][:first_name], last_name: params[:contact][:last_name])
          end
        end
      rescue AgileCRMWrapper::BadRequest
        logger.debug "AgileCRMWrapper: BadRequest for email: #{@primary_email}"
      end
      @email = Email.find_by(address: @primary_email)
      @email ||= Email.create(address: @primary_email, is_primary: true)
      @contact = @email.try(:contact)
      if @contact.nil?
        @contact = Contact.create( contact_params )
        @email.contact_id = @contact.id
        @email.save
      else
        @contact.update_attributes( contact_params )
        if @contact.primary_email.blank?
          @email.update_attribute(:is_primary, true)
        end
      end
      render json: {}, :callback => params[:callback], :status => 200
    end



  end

  def create
    @primary_email = params[:contact].try(:[], :emails_attributes).try(:[], "0").try(:[],:address)
    @primary_email ||= params[:contact].try(:[], :emails_attributes).try(:[], :"0").try(:[],:address)
    @primary_email ||= params[:contact].try(:[], :emails_attributes).try(:[], 0).try(:[],:address)
    @fc_questionaire = params[:contact].try(:[], :fc_questionaire_attributes)
    params[:contact].delete(:emails_attributes)
    params[:contact].delete(:fc_questionaire_attributes)
    if @primary_email.blank?
      respond_to do |format|
        format.js { render partial: 'home/register_error', locals: { error_msg: 'Valid Email is required'} }
        format.html { redirect_to pre_signup_path, alert: 'All information is required!' }
        format.json { render json: {error: 'All information is required'}, :status => 400 }
      end
      return
    else
      begin
        agile_contact = AgileCRMWrapper::Contact.search_by_email( @primary_email )
        if agile_contact.nil?
          agile_contact = AgileCRMWrapper::Contact.create( email: @primary_email,
                                                           first_name: params[:contact][:first_name],
                                                           last_name: params[:contact][:last_name] )
        else
          if params[:contact] &&  params[:contact][:first_name] && params[:contact][:last_name]
            agile_contact.update(first_name: params[:contact][:first_name], last_name: params[:contact][:last_name])
          end
        end
      rescue AgileCRMWrapper::BadRequest
        logger.debug "AgileCRMWrapper: BadRequest for email: #{@primary_email}"
      end
      @email = Email.find_by(address: @primary_email)
      @email ||= Email.create(address: @primary_email, is_primary: true)
      @contact = @email.try(:contact)
      if @contact.nil?
        @contact = Contact.create( contact_params )
        @email.contact_id = @contact.id
        @email.save
      else
        if @contact.update_attributes( contact_params )
          if @contact.primary_email.blank?
            @email.update_attribute(:is_primary, true)
          end
        else
          logger.error "Unable to create contact (#{@primary_email}): #{@contact.errors.full_messages.to_sentence}"
          respond_to do |format|
            format.js { render partial: 'home/register_error', locals: { error_msg: @contact.errors.full_messages.to_sentence}}
            format.html { redirect_to pre_signup_path, alert: @contact.errors.full_messages.to_sentence }
            format.json { render json:  {error: @contact.errors.full_messages }, :status => 400 }
          end
          return nil
        end

      end

    end

    unless @contact.valid? && @contact.persisted?
      logger.error "Unable to create contact (#{@primary_email}): #{@contact.errors.full_messages.to_sentence}"
      respond_to do |format|
        format.js { render partial: 'home/register_error', locals: { error_msg: @contact.errors.full_messages.to_sentence}}
        format.html { redirect_to pre_signup_path, alert: @contact.errors.full_messages.to_sentence }
        format.json { render json:  {error: @contact.errors.full_messages }, :status => 400 }
      end
      return nil
    end


    if params[:contact_us_message]
      # This is a Contact Us message
      ContactMailer.contactus_email(@contact, params[:contact_us_message]).deliver_later
      respond_to do |format|
        format.html { redirect_to pre_signup_thank_you_path, notice: 'Message was successfully received!' }
        format.json { render json: {}, :status => 200 }
      end
    else
        if params[:commit] == "Register for Kudoso's Founder's Circle"

          valid = true

          %w( first_name last_name address1 city state zip).each do |param|
            if @contact[param].blank?
              logger.error "FC Questionaire field: #{param} blank!"
             valid = false
            end

          end

          %w( kids_2_6 kids_7_12 kids_13_18 mobile_devices consumer_electronics computers favorite_feature prefer_buy ).each do |param|
            if @fc_questionaire[param].blank?
              logger.error "FC Questionaire field: #{param} blank!"
              valid = false
            end

          end
          if valid

            @contact.create_fc_questionaire(@fc_questionaire)

            agile_contact.update(tags: ["founders circle applicant", "newsletter"]) unless agile_contact.nil?
            respond_to do |format|
              format.js { render partial: 'home/register' }
            end
          else
            respond_to do |format|
              format.js { render partial: 'home/register_error', locals: { error_msg: 'All information for Founders Circle is required'} }
            end
          end

        else
          # This is a Newsletter signup

          if @email
            agile_contact.update(tags: ["newsletter"]) unless agile_contact.nil?
            respond_to do |format|
              format.js { render partial: 'home/register_newsletter' }
              format.html { redirect_to pre_signup_path, alert: 'Sorry, you are already signed up!' }
              format.json { render json: { error: 'Sorry, this email address is already registered.'}, :status => 409 }
            end
          else
            if @contact.valid?
              respond_to do |format|
                format.js { head 204 }
                format.html { redirect_to pre_signup_thank_you_path, notice: 'Information was successfully received!' }
                format.json { render json: {}, :status => 200 }
              end

            else
              logger.info  @contact.errors.full_messages.to_sentence
              respond_to do |format|
                format.js { render partial: 'home/register_error', locals: { error_msg: @contact.errors.full_messages.to_sentence}}
                format.html { redirect_to pre_signup_path, alert: @contact.errors.full_messages.to_sentence }
                format.json { render json:  {error: @contact.errors.full_messages }, :status => 500 }
              end
            end
          end
        end



    end



  end


  private


    def contact_params
      params.require(:contact).permit(:first_name,
                                      :last_name,
                                      :company,
                                      :primary_email_id,
                                      :address1,
                                      :address2,
                                      :city, :state, :zip,
                                      :address_type_id,
                                      :phone,
                                      :phone_type_id,
                                      :last_contact,
                                      :do_not_call,
                                      :do_not_email,
                                      :contact_type_id,
                                      fc_questionaire_attributes: [ :kids_2_6, :kids_7_12, :kids_13_18,
                                                                    :mobile_devices, :consumer_electronics, :computers,
                                                                    :favorite_feature, :prefer_buy, :comments],
                                      emails_attributes: [ :address ])
    end
end
