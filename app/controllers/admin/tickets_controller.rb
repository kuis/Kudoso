class Admin::TicketsController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @ticket_types = TicketType.all
    params[:ticket_type_id] ||= @ticket_types.first.id
    params[:page] ||= 1
    params[:per_page] ||= 25
    params[:open] ||= true
    params[:my_tickets] ||= false
    @ticket_type = TicketType.find(params[:ticket_type_id])
    @tickets = Ticket.where(nil).order(:date_openned)
    @tickets = @tickets.open(params[:open])
    @tickets = @tickets.assigned_to(params[:assigned_to_id])
    @tickets = @tickets.where(ticket_type_id: params[:ticket_type_id]).page(params[:page]).per(params[:per_page])


    respond_with(@tickets)
  end

  def show
    respond_with(@ticket)
  end

  def new
    @ticket = Ticket.new
    respond_with([:admin, @ticket])
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.contact.nil?
      @ticket.contact = @ticket.user.member.contact if @ticket.user.present?
    end
    @ticket.save
    respond_with([:admin, @ticket])
  end

  def update
    if params[:ticket_close]
      params[:ticket][:date_closed] = Time.now
      params[:ticket][:assigned_to_id] = current_user.id if @ticket.assigned_to_id.blank?
    end
    @ticket.update(ticket_params)
    respond_with([:admin, @ticket])
  end

  def destroy
    redirect_to admin_tickets_path, notice: 'Sorry, tickets cannot be destroy'
  end

  private


    def ticket_params
      params.require(:ticket).permit(:assigned_to_id, :user_id, :contact_id, :ticket_type_id, :date_openned, :date_closed, :status, notes_attributes: [:ticket_id, :note_type_id, :title, :body])
    end
end
