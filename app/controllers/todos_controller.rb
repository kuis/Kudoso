class TodosController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :family
  load_and_authorize_resource :todo, through: :family

  respond_to :html

  def index
    respond_with(@todos)
  end

  def show
    respond_with(@todo)
  end

  def new
    @todo = Todo.new
    respond_with(@todo)
  end

  def edit
  end

  def create
    @todo_template = TodoTemplate.find(params[:todo_template_id])
    @family = Family.find(params[:family_id])
    if @todo_template
      @todo = @family.todos.build({name: @todo_template.name, description: @todo_template.description, schedule: @todo_template.schedule, todo_template_id: @todo_template.id})
      @todo.active = true
    else
      @todo = Todo.new(todo_params)
      @todo.family = @family
    end

    respond_to do |format|
      if @family.present? && @todo.save || @todo_template.present?
        format.html { redirect_to @family }
      else
        format.html { render :new }
      end

    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to family_path(@family), notice: 'ToDo was successfully updated.' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to family_path(@family), notice: 'ToDo was successfully destroyed.' }
      format.json { render :show, status: :created, location: @todo }
    end
  end

  private

    def todo_params
      params.require(:todo).permit(:name, :description, :required, :kudos, :active, :schedule)
    end
end
