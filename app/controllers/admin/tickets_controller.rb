class Admin::TicketsController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @tickets = Ticket.all
    respond_with(@tickets)
  end

  def show
    respond_with(@ticket)
  end

  def new
    @ticket = Ticket.new
    respond_with(@ticket)
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.save
    respond_with(@ticket)
  end

  def update
    @ticket.update(ticket_params)
    respond_with(@ticket)
  end

  def destroy
    @ticket.destroy
    respond_with(@ticket)
  end

  private


    def ticket_params
      params.require(:ticket).permit(:assigned_to_id, :user_id, :contact_id, :ticket_type_id, :date_openned, :date_closed, :status)
    end
end
