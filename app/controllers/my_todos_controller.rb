class MyTodosController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :my_todo, through: :member

  respond_to :html, :js

  def index
    @my_todos = @member.my_todos.all
    respond_with(@my_todos)
  end

  def show
    respond_with(@my_todo)
  end

  def new
    @todo_schedule = TodoSchedule.find(params[:todo_schedule_id])
    @my_todo = MyTodo.new(member_id: @member.id, todo_schedule_id: @todo_schedule.id)
    respond_with(@my_todo)
  end

  def edit
  end

  def create
    begin
      @todo_schedule = TodoSchedule.find(params[:todo_schedule_id] )
    rescue
      logger.error 'No todo_schedule for my todo'
      @todo_schedule = nil
    end

    if @todo_schedule
      @my_todo = MyTodo.new(my_todo_params.merge({member_id: @member.id, todo_schedule_id: @todo_schedule.id}))

      respond_to do |format|
        if @my_todo.save
          @member.reload
          format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal todo was successfully created' }
          format.js { render :update }
        else
          logger.error "My todo save failed: #{@my_todo.errors.full_messages}"
          flash.now[:error] = "#{@my_todo.errors.full_messages}"
          format.html { render :new }
          format.js { render :update }
        end
      end
    else
      flash[:error] = 'An error occurred trying to create the todo, please try again.'
      redirect_to [@family, @member]
    end


  end

  def update
    respond_to do |format|
      if @my_todo.update(my_todo_params.merge({member_id: @member.id}))
        @member.reload
        @my_todo.reload
        format.html { redirect_to family_member_path(@member.family, @member), notice: 'Personal todo was successfully created' }
        format.js { render :update }
      else
        format.html { render :edit }
        format.js { render :update }
      end
    end
  end

  def destroy
    @my_todo.destroy
    redirect_to [@family, @member]
  end

  private

    def my_todo_params
      params.require(:my_todo).permit(:due_date, :due_time, :complete, :verify, :verified_at, :verified_by, :todo_schedule_id)
    end
end
