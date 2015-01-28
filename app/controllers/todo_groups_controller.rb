class TodoGroupsController < ApplicationController
  before_action :authenticate_member! unless @current_user.present?
  load_and_authorize_resource

  respond_to :html

  def index
    @family = Family.find(params[:family_id]) if params[:family_id]
    respond_with(@todo_groups)
  end

  def show
    respond_with(@todo_group)
  end

  def new
    @todo_group = TodoGroup.new
    respond_with(@todo_group)
  end

  def edit
  end

  def create
    @todo_group = TodoGroup.new(todo_group_params)
    @todo_group.save
    respond_with(@todo_group)
  end

  def update
    @todo_group.update(todo_group_params)
    respond_with(@todo_group)
  end

  def destroy
    @todo_group.destroy
    respond_with(@todo_group)
  end

  def assign
    @family = Family.includes(:todos).find(params[:family_id])
    if @family.present? && ( current_user.present? && (current_user.admin? || current_user.member.family_id == @family.try(:id) ) ) || ( current_member.present? && current_member.family_id == @family.try(:id))
      @members = ( params[:todo_group].nil? || params[:todo_group][:member_ids].nil? ) ? Array.new : params[:todo_group][:member_ids]
      @todo_group = TodoGroup.find(params[:id])

      @family.assign_group(@todo_group, @members)
    else
      logger.warn "#{current_user.present? ? "User #{current_user.id}" : "Member #{current_member.id}"} attempted to assign todo_group #{params[:id]} to family #{params[:family_id]} (#{current_user.present? ? "#{current_user.member.family_id}" : "#{current_member.family_id}"}) but failed."
      flash[:error] = 'Sorry, an error occurred trying to assign this todo group, please try again.'
    end


    redirect_to @family
  end

  private

    def todo_group_params
      params.require(:todo_group).permit(:name, :rec_min_age, :rec_max_age, :active, :todo_template_ids => [], :member_ids => [], todo_templates_attributes: [ :id, :name, :description, :schedule, :active, :_destroy ])
    end
end
