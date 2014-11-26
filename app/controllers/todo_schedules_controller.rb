class TodoSchedulesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :family
  load_and_authorize_resource :todo, through: :family
  load_and_authorize_resource :todo_schedule, through: :todo



  respond_to :html, :json

  def index
    respond_with(@todo_schedules)
  end

  def show
    respond_with(@todo_schedule)
  end

  def edit
  end

  def create
    @todo_schedule = TodoSchedule.new(todo_schedule_params)
    @todo_schedule.todo = @todo
    schedule = IceCube::Schedule.new
    schedule.start_time = Chronic.parse(params[:todo_schedule][:start_date])
    schedule.end_time = Chronic.parse(params[:todo_schedule][:end_date])
    schedule.add_recurrence_rule IceCube::Rule.from_yaml(@todo.schedule)
    @todo_schedule.schedule = schedule.to_yaml
    @todo_schedule.active = true
    @todo_schedule.save

    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  def update
    @todo_schedule.update(todo_schedule_params)
    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  def destroy
    @todo_schedule.destroy
    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  private

    def todo_schedule_params
      params.require(:todo_schedule).permit(:member_id, :start_date, :end_date, :active, :schedule, :notes)
    end
end
