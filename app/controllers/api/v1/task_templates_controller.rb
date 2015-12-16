module Api
  module V1
    class TaskTemplatesController < ApiController

      resource_description do
        short 'API Task Templates (also know as Task Templates)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Task_Template (Task Templates)
          Tasks are parent directed activities, the task templates are a collection of pre-defined templates that
          Kudoso provides to make it easy for parents to assign them.

          Task_templates should not be confused with Tasks or my_tasks.  Here is how the association works:
          1. When a task_template is "assigned", a Task is created at the FAMILY level
          2. A task_schedule is created (initially from the defaults in the task_template) which links the task to
             a family member
          3. A my_task is an instance of a task_schedule for a member on a particular day.  In effect, the my_task
             records the details of the actual task performed

          === Key attributes
          * __rec_min_age__ This is the recommended minimum age for the task
          * __rec_max_age__ This is the recommended maximum age for the task
          * __def_min_age__ If the member's age is >= to def_min_age it should be selected by default (in the wizard)
          * __def_max_age__ If the member's age is <= to def_max_age it should be selected by default (in the wizard)

        EOS
      end

      api :GET, "/v1/families/:family_id/members/:member_id/task_templates", "Retrieve all task templates assigned to a member"
      api :GET, "/v1/task_templates", "Retrieve all task templates"
      def index
        messages = init_messages
        if params[:family_id] && params[:member_id]
          begin
            @family = Family.find(params[:family_id])
            if @current_user.try(:admin) || (@current_member.try(:family) == @family )
              @member = @family.members.find(params[:member_id])
              render :json => { :task_templates => @member.task_templates, :messages => messages }, :status => 200
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
        else
          @task_templates = TaskTemplate.all
          render :json => { :task_templates => @task_templates, :messages => messages }, :status => 200
        end


      end

      api :GET, "/v1/task_templates/:task_template_id", "Retrieve a single task template"
      def show
        messages = init_messages
        begin
          @task_template = TaskTemplate.find(params[:id])
          render :json => { :task_template => @task_template, :messages => messages }, :status => 200


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/families/:family_id/members/:member_id/task_templates/:task_template_id/assign", "Assign a task_template to a member (must be a parent)"
      def assign
        messages = init_messages
        begin
          @task_template = TaskTemplate.find(params[:id])
          @family = Family.find(params[:family_id])
          @member = Member.find(params[:member_id])

          if @family && @member && @task_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.assign_template(@task_template, [ @member ])
            render :json => { :messages => messages }, :status => 200
          end


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :DELETE, "/v1/families/:family_id/members/:member_id/task_templates/:task_template_id/unassign", "Remove a task_template from a member (must be a parent)"
      def unassign
        messages = init_messages
        begin
          @task_template = TaskTemplate.find(params[:id])
          @family = Family.find(params[:family_id])
          @member = Member.find(params[:member_id])

          if @family && @member && @task_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.remove_template(@task_template, [ @member ])
            render :json => { :messages => messages }, :status => 200
          end


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

    end
  end
end
