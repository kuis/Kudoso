module Api
  module V1
    class TodoTemplatesController < ApiController

      resource_description do
        short 'API Todo Templates (also know as Task Templates)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Todo_Template (Task Templates)
          Tasks are parent directed activities, the task templates are a collection of pre-defined templates that
          Kudoso provides to make it easy for parents to assign them.

          Todo_templates should not be confused with Todos or my_todos.  Here is how the association works:
          1. When a todo_template is "assigned", a Todo is created at the FAMILY level
          2. A todo_schedule is created (initially from the defaults in the todo_template) which links the todo to
             a family member
          3. A my_todo is an instance of a todo_schedule for a member on a particular day.  In effect, the my_todo
             records the details of the actual task performed

          === Key attributes
          * __rec_min_age__ This is the recommended minimum age for the task
          * __rec_max_age__ This is the recommended maximum age for the task
          * __def_min_age__ If the member's age is >= to def_min_age it should be selected by default (in the wizard)
          * __def_max_age__ If the member's age is <= to def_max_age it should be selected by default (in the wizard)

        EOS
      end

      api :GET, "/v1/families/:family_id/members/:member_id/todo_templates", "Retrieve all task templates assigned to a member"
      api :GET, "/v1/todo_templates", "Retrieve all task templates"
      def index
        messages = init_messages
        if params[:family_id] && params[:member_id]
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            @member = @family.members.find(params[:member_id])
            render :json => { :todo_templates => @member.todo_templates, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end
        else
          @todo_templates = TodoTemplate.all
          render :json => { :todo_templates => @todo_templates, :messages => messages }, :status => 200
        end


      end

      api :GET, "/v1/todo_templates/:todo_template_id", "Retrieve a single task template"
      def show
        messages = init_messages
        @todo_template = TodoTemplate.find(params[:id])
        render :json => { :todo_template => @todo_template, :messages => messages }, :status => 200
      end

      api :POST, "/v1/families/:family_id/members/:member_id/todo_templates/:todo_template_id/assign", "Assign a todo_template to a member (must be a parent)"
      def assign
        messages = init_messages
        @todo_template = TodoTemplate.find(params[:id])
        @family = Family.find(params[:family_id])
        @member = Member.find(params[:member_id])

        if @family && @member && @todo_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
          @family.assign_template(@todo_template, [ @member ])
          render :json => { :messages => messages }, :status => 200
        end
      end

      api :DELETE, "/v1/families/:family_id/members/:member_id/todo_templates/:todo_template_id/unassign", "Remove a todo_template from a member (must be a parent)"
      def unassign
        messages = init_messages
        @todo_template = TodoTemplate.find(params[:id])
        @family = Family.find(params[:family_id])
        @member = Member.find(params[:member_id])

        if @family && @member && @todo_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
          @family.remove_template(@todo_template, [ @member ])
          render :json => { :messages => messages }, :status => 200
        end
      end

    end
  end
end
