class TodoTemplatesController < ApplicationController
  before_action :set_todo_template, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @todo_templates = TodoTemplate.all
    respond_with(@todo_templates)
  end

  def show
    respond_with(@todo_template)
  end

  def new
    @todo_template = TodoTemplate.new
    respond_with(@todo_template)
  end

  def edit
  end

  def create
    @todo_template = TodoTemplate.new(todo_template_params)
    @todo_template.save
    respond_with(@todo_template)
  end

  def update
    @todo_template.update(todo_template_params)
    respond_with(@todo_template)
  end

  def destroy
    @todo_template.destroy
    respond_with(@todo_template)
  end

  private
    def set_todo_template
      @todo_template = TodoTemplate.find(params[:id])
    end

    def todo_template_params
      params.require(:todo_template).permit(:name, :description, :schedule, :active)
    end
end
