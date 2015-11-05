module Api
  module V1
    class MyTodosController < ApiController
      # This controller is only callable through the family and member
      # /api/v1/family/:family_id/members/:member_id/my_todos

      resource_description do
        short 'API my_todos (also know as Tasks)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Tasks
          Tasks are parent directed activities, if marked as "required?" then they must be completed before
          the member is allowed to do other activities

        EOS
      end


      api :GET, "/v1/families/:family_id/members/:member_id/my_todos", "Retrieve all tasks for a member (default: today's tasks)"
      param :start_date, Date, desc: "Optionnaly specify a start date"
      param :end_date, Date, desc: "Optionnaly specify an end date"
      example <<END
{"id"=>368,
 "todo_schedule_id"=>4,
 "member_id"=>3,
 "due_date"=>Sat, 19 Sep 2015 23:59:59 MDT -06:00,
 "due_time"=>nil,
 "complete"=>true,
 "verify"=>nil,
 "verified_at"=>nil,
 "verified_by"=>nil,
 "created_at"=>Tue, 22 Sep 2015 06:31:55 MDT -06:00,
 "updated_at"=>Tue, 22 Sep 2015 06:32:03 MDT -06:00,
 "required?"=>nil,
 "todo_schedule"=>
  {"id"=>4,
   "todo_id"=>2,
   "member_id"=>3,
   "start_date"=>Sat, 08 Aug 2015 00:00:00 MDT -06:00,
   "end_date"=>nil,
   "active"=>true,
   "notes"=>nil,
   "created_at"=>Tue, 22 Sep 2015 06:31:34 MDT -06:00,
   "updated_at"=>Tue, 22 Sep 2015 06:31:34 MDT -06:00,
   "todo"=>
    {"id"=>2,
     "name"=>"Brush hair",
     "description"=>"Look your best and get rid of that bed hed!",
     "required"=>nil,
     "kudos"=>20,
     "todo_template_id"=>2,
     "family_id"=>1,
     "active"=>true,
     "schedule"=>"---\n:validations: {}\n:rule_type: IceCube::DailyRule\n:interval: 1\n",
     "created_at"=>Tue, 22 Sep 2015 06:31:33 MDT -06:00,
     "updated_at"=>Tue, 22 Sep 2015 06:31:33 MDT -06:00,
     "steps"=>["one", "two"]}}}
END

      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == params[:member_id]
            @member = @family.members.find(params[:member_id])
            params[:start_date] ||= Date.today
            params[:end_date] ||= Date.today
            logger.debug "Returning JSON: #{@member.todos(params[:start_date], params[:end_date]).as_json}"
            render :json => { my_todos: @member.todos(params[:start_date], params[:end_date]).as_json, :messages => messages }, :status => 200
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

      api :GET, "/v1/families/:family_id/members/:member_id/my_todos/:my_todo_id", "Retrieve a task for a member"
      example '  {"id"=>403, "todo_schedule_id"=>1, "member_id"=>2, "due_date"=>Sat, 04 Jul 2015 23:59:59 MDT -06:00, "due_time"=>nil, "complete"=>nil, "verify"=>nil, "verified_at"=>nil, "verified_by"=>nil, "created_at"=>Sun, 05 Jul 2015 22:03:40 MDT -06:00, "updated_at"=>Sun, 05 Jul 2015 22:03:40 MDT -06:00} '
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == @my_todo.member_id
            render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 200
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

      api :POST, "/v1/families/:family_id/members/:member_id/my_todos", "Mark a task as complete"
      param :due_date, Date, desc: "Date of the task", required: true
      param :todo_schedule_id, Integer, desc: "The reference to the appropriate todo_schedule", required: true
      param :complete, [true, false], required: true
      param :verify, [true, false], desc: "Set to true if parent is required to verify this task as complete"
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member
            @my_todo = @member.my_todos.create(my_todo_create_params)
            if @my_todo.valid?
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 400
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

      api :PATCH, "/v1/families/:family_id/members/:member_id/my_todos/:my_todo_id", "Mark a task as complete"
      param :complete, [true, false], required: true
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member
            if @my_todo.update_attributes(my_todo_create_params)
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 400
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

      api :POST, "/v1/families/:family_id/members/:member_id/my_todos/:my_todo_id/verify", "Mark a task as verified (only as a parent)"
      def verify
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            if @my_todo.verify!(@current_member)
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo.as_json, :messages => messages }, :status => 400
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
      def my_todo_create_params
        params.require(:my_todo).permit(:due_date, :due_time, :complete, :verify, :todo_schedule_id)
      end

    end

  end
end
