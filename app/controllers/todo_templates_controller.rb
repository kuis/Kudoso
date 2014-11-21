class TodoTemplatesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

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

    respond_to do |format|
      if @todo_template.save
        format.html { redirect_to todo_templates_path, notice: 'ToDo Template was successfully created.' }
        format.json { render :show, status: :created, location: @todo_template }
      else
        format.html { render :new }
        format.json { render json: @todo_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo_template.update(todo_template_params)
        format.html { redirect_to todo_templates_path, notice: 'ToDo Template was successfully updated.' }
        format.json { render :show, status: :created, location: @todo_template }
      else
        format.html { render :new }
        format.json { render json: @todo_template.errors, status: :unprocessable_entity }
      end
    end
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
