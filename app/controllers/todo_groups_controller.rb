class TodoGroupsController < ApplicationController
  before_action :set_todo_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @todo_groups = TodoGroup.all
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

  private
    def set_todo_group
      @todo_group = TodoGroup.find(params[:id])
    end

    def todo_group_params
      params.require(:todo_group).permit(:name, :rec_min_age, :rec_max_age, :active)
    end
end
