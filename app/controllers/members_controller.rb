class MembersController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family

  respond_to :html, :json, :js

  # GET /members
  # GET /members.json
  def index
    @members = @family.members.all
    respond_with(@members)
  end

  # GET /members/1
  # GET /members/1.json
  def show

  end

  # GET /members/new
  def new
    @family = Family.find(params[:family_id])
    @parent = @family.members.where(parent: true).limit(1).first
    @member = Member.new(family_id: @family.id)
    @member.contact = Contact.new(last_name: @parent.last_name)
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member].merge({family_id:@family.id}))
    @member.username = @member.username.downcase
    if @member.save
      respond_to do |format|
        format.html { redirect_to  [@family,@member], notice: 'Family member was successfully created.'}
        format.json { render json: @member }
        format.js
      end

    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { message: @member.errors.full_messages }, status: 409 }
      end
    end

  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    params[:member][:birth_date] = Chronic.parse(params[:member][:birth_date]) if params[:member][:birth_date]
    if @member.update(member_params)
      flash[:notice] = 'Family member was successfully updated.'
      respond_with(@member, location: [@family,@member])
    else
      render :edit
    end

  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    if @member.destroy
      flash[:notice] = 'Family member was successfully deleted.'
    else
      flash[:error] = "Family member was not deleted. #{@member.errors.full_messages[0]}"
    end
    redirect_to family_members_path(@family)
  end

  private


  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:username, :parent, :password, :password_confirmation, :birth_date, :contact_attributes => [:first_name, :last_name, :id])
  end
end
