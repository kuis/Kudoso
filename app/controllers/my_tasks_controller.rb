class MyTasksController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :my_task, through: :member

  respond_to :html, :js

  def index
    @my_tasks = @member.my_tasks.all
    respond_with(@my_tasks)
  end

  def show
    respond_with(@my_task)
  end

  def new
    @task_schedule = TaskSchedule.find(params[:task_schedule_id])
    @my_task = MyTask.new(member_id: @member.id, task_schedule_id: @task_schedule.id)
    respond_with(@my_task)
  end

  def edit
  end

  def create
    begin
      @task_schedule = TaskSchedule.find(params[:task_schedule_id] )
    rescue
      logger.error 'No task_schedule for my task'
      @task_schedule = nil
    end

    if @task_schedule
      @my_task = MyTask.new(my_task_params.merge({member_id: @member.id, task_schedule_id: @task_schedule.id}))

      respond_to do |format|
        if @my_task.save
          @member.reload
          format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal task was successfully created' }
          format.js { render :update }
        else
          logger.error "My task save failed: #{@my_task.errors.full_messages}"
          flash.now[:error] = "#{@my_task.errors.full_messages}"
          format.html { render :new }
          format.js { render :update }
        end
      end
    else
      flash[:error] = 'An error occurred trying to create the task, please try again.'
      redirect_to [@family, @member]
    end


  end

  def update
    respond_to do |format|
      if @my_task.update(my_task_params.merge({member_id: @member.id}))
        @member.reload
        @my_task.reload
        format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal task was successfully created' }
        format.js { render :update }
      else
        format.html { render :edit }
        format.js { render :update }
      end
    end
  end

  def destroy
    @my_task.destroy
    redirect_to [@family, @member]
  end

  private

    def my_task_params
      params.require(:my_task).permit(:due_date, :due_time, :complete, :verify, :verified_at, :verified_by, :task_schedule_id)
    end
end
