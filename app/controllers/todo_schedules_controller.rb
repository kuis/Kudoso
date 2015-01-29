class TodoSchedulesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :todo, through: :family
  load_and_authorize_resource :todo_schedule, through: :todo



  respond_to :html, :json

  def index
    @todo_schedules = @todo.todo_schedules.all
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
    @todo_schedule.active = true
    @todo_schedule.save

    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  def update
    new_ts = @todo_schedule.dup
    rrules = todo_schedule_params[:schedule_rrules_attributes] || []
    new_params = todo_schedule_params
    new_params[:schedule_rrules_attributes] = []
    new_ts.assign_attributes(new_params)

    if @todo_schedule.my_todos.where('due_date <= ?', Date.today.end_of_day).count > 0
      @todo_schedule.update_attribute(:end_date, Date.today.end_of_day)
      new_ts.start_date = Date.tomorrow.beginning_of_day
    else
      if @todo_schedule.start_date >= Date.today.beginning_of_day
        @todo_schedule.destroy!
      else
        @todo_schedule.update_attribute(:end_date, Date.yesterday.end_of_day)
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
      format.html { redirect_to [@family, @todo_schedule.member] }
    end
  end

  def destroy
    if @todo_schedule.start_date > Date.today.end_of_day
      @todo_schedule.destroy
    else
      @todo_schedule.update_attribute(:end_date, Date.today.end_of_day)
    end

    respond_to do |format|
      format.html { redirect_to @family }
    end
  end

  private

    def todo_schedule_params
      params.require(:todo_schedule).permit(:todo_id, :member_id, :start_date, :end_date, :active, :schedule, :notes, schedule_rrules_attributes: [ :id, :todo_schedule_id, :rule, :_destroy ])
    end
end
