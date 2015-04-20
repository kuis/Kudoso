class Admin::ContactsController < AdminController
  load_and_authorize_resource
  respond_to :html

  def index
    @contact_type = params[:contact_type_id]
    if @contact_type
      @contacts = Contact.where(contact_type_id: @contact_type)
    else
      @contacts = Contact.all
    end
    @contact_types = ContactType.all
    respond_with(@contacts)
  end

  def show
    respond_with(@contact)
  end

  def new
    @contact = Contact.new
    respond_with([:admin, @contact])
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    respond_with([:admin, @contact])
  end

  def update
    @contact.update(contact_params)
    respond_with([:admin, @contact])
  end

  def destroy
    if @contact.destroy
      flash[:notice] = 'Contact was successfully deleted.'
    else
      flash[:error] = "Contact was not deleted. #{@contact.errors.full_messages[0]}"
    end
    redirect_to admin_contacts_path
  end

  private


    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :company, :primary_email_id, :address1, :address2, :city, :state, :zip, :address_type_id, :phone, :phone_type_id, :last_contact, :do_not_call, :do_not_email, :contact_type_id)
    end
end
