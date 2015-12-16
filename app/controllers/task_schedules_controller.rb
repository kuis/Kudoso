class TaskSchedulesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :task, through: :family
  load_and_authorize_resource :task_schedule, through: :task



  respond_to :html, :json

  def index
    @task_schedules = @task.task_schedules.all
    respond_with(@task_schedules)
  end

  def show
    respond_with(@task_schedule)
  end

  def edit
  end

  def create
    @task_schedule = TaskSchedule.new(task_schedule_params)
    @task_schedule.task = @task
    @task_schedule.active = true
    @task_schedule.save

    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  def update
    new_ts = @task_schedule.dup
    rrules = task_schedule_params[:schedule_rrules_attributes] || []
    new_params = task_schedule_params
    new_params[:schedule_rrules_attributes] = []
    new_ts.assign_attributes(new_params)

    if @task_schedule.my_tasks.where('due_date <= ?', Date.today.end_of_day).count > 0
      @task_schedule.update_attribute(:end_date, Date.today.end_of_day)
      new_ts.start_date = Date.tomorrow.beginning_of_day
    else
      if @task_schedule.start_date >= Date.today.beginning_of_day
        @task_schedule.destroy!
      else
        @task_schedule.update_attribute(:end_date, Date.yesterday.end_of_day)
      end
      new_ts.start_date = Date.today.beginning_of_day if new_ts.start_date.blank? || new_ts.start_date < Date.today.beginning_of_day
    end

    if new_ts.save # we need the new schedule to be saved before building new rules
      rrules.try(:to_h).each do |key, rule|
        rule.delete(:id)
        del = rule.delete("_destroy")
        new_ts.schedule_rrules.create(rule) unless del == "true"
      end
    else
      flash[:error] = new_ts.errors.full_messages
    end


    respond_to do |format|
      format.html { redirect_to [@family, @task_schedule.member] }
    end
  end

  def destroy
    if @task_schedule.start_date > Date.today.end_of_day
      @task_schedule.destroy
    else
      @task_schedule.update_attribute(:end_date, Date.today.end_of_day)
    end

    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  private

    def task_schedule_params
      params.require(:task_schedule).permit(:task_id, :member_id, :start_date, :end_date, :active, :schedule, :notes, schedule_rrules_attributes: [ :id, :task_schedule_id, :rule, :_destroy ])
    end
end
