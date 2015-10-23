class ChargesController < ApplicationController

  def create
    messages = init_messages

    token = params[:stripeToken]
    plan = eval("Stripe::Plans::" + params[:plan].upcase)
    if token.nil? || plan.nil?
      logger.warn "Invalid token or plan"
      messages[:error] << 'Invalid Token or Plan'
      render json: {messages: messages}, status: 400
    else
      case plan.id
        when :ohana_annual
          # we will do only a one time charge until the service is active
          user = User.find(params[:id]) if params[:id]
          unless user
            user = User.create(user_params)
          end
          if user.stripe_customer_id
            #already have customer just charge them
          else
            #setup customer
            customer = Stripe::Customer.create(
                :source => token,
                :description => "#{user.email}"
            )
            user.update_attributes({stripe_customer_id: customer.id, plan: plan.id.to_s})
            begin
              charge = Stripe::Charge.create(
                  :amount => plan.amount, # in cents
                  :currency => plan.currency,
                  :customer => customer.id
              )
              invoice = user.invoices.create(amount: plan.amount)
              invoice.payments.create(amount: plan.amount, description: charge.id)

              # add to Agile
              begin
                address = { address: params[:user][:address], city: params[:user][:city], state: params[:user][:state], zip: params[:user][:zip], country: params[:user][:country]}.to_json
                agile_contact = AgileCRMWrapper::Contact.search_by_email( user.email )
                if agile_contact.nil?
                  agile_contact = AgileCRMWrapper::Contact.create( email: user.email,
                                                                   first_name: user.first_name,
                                                                   last_name: user.last_name,
                                                                   address: address,
                                                                   tags: [ 'ohana', 'newsletter' ]
                  )
                else
                  tags = agile_contact.tags
                  tags << 'ohana'
                  agile_contact.update(first_name: user.first_name, last_name:user.last_name, address: address, tags: tags)

                end
              rescue AgileCRMWrapper::BadRequest
                logger.debug "AgileCRMWrapper: BadRequest for email: #{user.email}"
              end

              render json: {messages: messages}, status: 200
            rescue Stripe::CardError => e
              # The card has been declined
              logger.warn "User ID(#{user.id} card declined"
              messages[:error] << 'Card was declined'
              render json: {messages: messages}, status: 400

            end
          end

        else
          logger.error "Plan #{plan.id} not yet implemented!"
          messages[:error] << 'Plan processing is not yet implemneted'

          render json: {messages: messages}, status: 400

      end

    end





  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end