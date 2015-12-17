class TasksController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :task, through: :family , except: :create
  authorize_resource :task, through: :family, only: :create

  respond_to :html

  def index
    respond_with(@tasks)
  end

  def show
    respond_with(@task)
  end

  def new
    @task = Task.new
    respond_with(@task)
  end

  def edit
  end

  def create
    @task_template = TaskTemplate.find(params[:task_template_id]) if params[:task_template_id].present?
    @family = Family.find(params[:family_id])
    if @task_template
      @task = @family.tasks.build({name: @task_template.name, description: @task_template.description, schedule: @task_template.schedule, task_template_id: @task_template.id})
      @task.active = true
    else
      @task = Task.new(task_params)
      @task.family = @family
    end

    respond_to do |format|
      if @family.present? && @task.save || @task_template.present?
        format.html { redirect_to @family }
      else
        format.html { render :new }
      end

    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to family_path(@family), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to family_path(@family), notice: 'Task was successfully destroyed.' }
      format.json { render :show, status: :created, location: @task }
    end
  end

  private

    def task_params
      params.require(:task).permit(:name, :description, :required, :kudos, :active, :schedule)
    end
end
