class MyTodosController < ApplicationController
  before_action :load_helpers
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def index
    respond_with(@my_todos)
  end

  def show
    respond_with(@my_todo)
  end

  def new
    @my_todo = MyTodo.new(member_id: @member.id, todo_schedule_id: @todo_schedule.id)
    respond_with(@my_todo)
  end

  def edit
  end

  def create
    @my_todo = MyTodo.new(my_todo_params.merge({member_id: @member.id, todo_schedule_id: @todo_schedule.id}))

    respond_to do |format|
      if @my_todo.save
        @member.reload
        format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal todo was successfully created' }
        format.js { render :update }
      else
        format.html { render :new }
        format.js { render :update }
      end
    end

  end

  def update
    respond_to do |format|
      if @my_todo.update(my_todo_params.merge({member_id: @member.id, todo_schedule_id: @todo_schedule.id}))
        @member.reload
        format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal todo was successfully created' }
        format.js { render :update }
      else
        format.html { render :new }
        format.js { render :update }
      end
    end
  end

  def destroy
    @my_todo.destroy
    respond_with(@my_todo)
  end

  private

    def load_helpers
      @member = Member.find(params[:member_id])
      @todo_schedule = TodoSchedule.find(params[:todo_schedule_id])
    end
    def my_todo_params
      params.require(:my_todo).permit(:due_date, :due_time, :complete, :verify, :verified_at, :verified_by)
    end
end
