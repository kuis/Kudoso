class Admin::TaskTemplatesController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @task_templates = TaskTemplate.all
    respond_with(@task_templates)
  end

  def show
    respond_with(@task_template)
  end

  def new
    @task_template = TaskTemplate.new
    respond_with(@task_template)
  end

  def edit
  end

  def create
    @task_template = TaskTemplate.new(task_template_params)

    respond_to do |format|
      if @task_template.save
        format.html { redirect_to admin_task_templates_path, notice: 'Task Template was successfully created.' }
        format.json { render :show, status: :created, location: @task_template }
      else
        format.html { render :new }
        format.json { render json: @task_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task_template.update(task_template_params)
        format.html { redirect_to admin_task_templates_path, notice: 'Task Template was successfully updated.' }
        format.json { render :show, status: :created, location: @task_template }
      else
        format.html { render :edit }
        format.json { render json: @task_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task_template.destroy
    redirect_to admin_task_templates_path, notice: 'Task Template was successfully destroyed.'
  end

  private


    def task_template_params
      params.require(:task_template).permit(:name, :description, :rule, :active, :kudos, :required)
    end
end
