class TodoGroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: :assign

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
    @members = ( params[:todo_group].nil? || params[:todo_group][:member_ids].nil? ) ? Array.new : params[:todo_group][:member_ids]
    @todo_group = TodoGroup.find(params[:id])

    @family.assign_group(@todo_group, @members)


    redirect_to @family
  end

  private

    def todo_group_params
      params.require(:todo_group).permit(:name, :rec_min_age, :rec_max_age, :active, :todo_template_ids => [], :member_ids => [], todo_templates_attributes: [ :id, :name, :description, :schedule, :active, :_destroy ])
    end
end
