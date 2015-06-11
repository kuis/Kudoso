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
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    params[:member][:birth_date] = Chronic.parse(params[:member][:birth_date]).to_date.to_s(:db) if params[:member][:birth_date]
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
    params[:member][:birth_date] = Chronic.parse(params[:member][:birth_date]).to_date.to_s(:db) if params[:member][:birth_date]
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

  def assign_todo_group
    @todo_group = TodoGroup.find(params[:todo_group_id])
    if @todo_group
      @family.assign_group(@todo_group, [ @member.id ])
      respond_to do |format|
        format.html { redirect_to @family }
        format.json { render json: @member.my_todos }
      end

    else
      logger.warn "#{current_user.present? ? "User #{current_user.id}" : "Member #{current_member.id}"} attempted to assign todo_group #{params[:id]} to family #{params[:family_id]} (#{current_user.present? ? "#{current_user.member.family_id}" : "#{current_member.family_id}"}) but failed."
      respond_to do |format|
        format.html { redirect_to @family, error: 'Sorry, an error occurred trying to assign this todo group, please try again.' }
        format.json { render json: { message: 'Task Group or Member not found.'}, status: 404 }
      end
    end
  end

  private


  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:username, :parent, :password, :password_confirmation, :birth_date, :first_name, :last_name, :email)
  end
end
