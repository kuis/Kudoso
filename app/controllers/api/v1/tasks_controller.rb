module Api
  module V1
    class TasksController < ApiController
      # This controller is only callable through the family
      # /api/v1/family/:family_id/tasks

      resource_description do
        short 'Family Tasks (also know as Tasks)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Tasks (Tasks )
          Tasks are parent directed activities, as parents assign tasks to kids, a Task object is created at the family
          level to track that task across one or more schedules which assign the task to each child.

          Here is how the association works:
          1. When a task_template is "assigned", a Task is created at the FAMILY level
          2. A task_schedule is created (initially from the defaults in the task_template) which links the task to
             a family member
          3. A my_task is an instance of a task_schedule for a member on a particular day.  In effect, the my_task
             records the details of the actual task performed

        EOS
      end

      def_param_group :tasks do
        param :name, String, desc: 'The name of the task to be displayed in the task list/calendar', required: true
        param :description, String, desc: 'A more detailed description of the task to help guide the child'
        param :required, [true, false], desc: 'If a task is required, a child will be prevented from doing other activities until it is complete', required: true
        param :kudos, Integer, desc: 'The number of kudos that can be earned by completing the task', required: true
        param :active, [true, false], desc: 'Set to true in order to use', required: true
        param :schedule, String, desc: 'A YAML representation of an IceCube Recurring Rule.  See https://github.com/seejohnrun/ice_cube and https://github.com/GetJobber/recurring_select', required: true
      end

      api :GET, "/v1/families/:family_id/tasks", "Retrieve all tasks for the family"
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            render :json => { tasks: @family.tasks, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :GET, "/v1/families/:family_id/tasks/:task_id", "Retrieve a specific task for the family"
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @task = @family.tasks.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            render :json => { :task => @task, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family or Member not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/families/:family_id/tasks", "Create a new task (manual, not from a task_template)"
      param_group :tasks
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            @task = @family.tasks.create(task_create_params)
            if @task.valid?
              render :json => { :task => @task, :messages => messages }, :status => 200
            else
              messages[:error].concat @task.errors.full_messages
              render :json => { :task => @task, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :PATCH, "/v1/families/:family_id/tasks/:task_id", "Update a task"
      param_group :tasks
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @task = @family.tasks.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            if @task.update_attributes(task_create_params)
              render :json => { :task => @task, :messages => messages }, :status => 200
            else
              messages[:error].concat @task.errors.full_messages
              render :json => { :task => @task, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :DELETE, "/v1/families/:family_id/tasks/:task_id", "Delete a task"
      def destroy
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            @task = @family.tasks.find(params[:id])
            if @task.destroy
              render :json => { :task => @task, :messages => messages }, :status => 200
            else
              messages[:error].concat @task.errors.full_messages
              render :json => { :task => @task, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end



      private


      # Never trust parameters from the scary internet, only allow the white list through.
      def task_create_params
        params.require(:task).permit(:name, :description, :required, :kudos, :active, :schedule)
      end

    end

  end
end
