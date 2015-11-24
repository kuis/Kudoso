module Api
  module V1
    class TodoSchedulesController < ApiController

      resource_description do
        short 'API Todo Schedules (also know as Task Schedules)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Todo Schedules (Task Schedules)
          Tasks are parent directed activities, the task schedules allow parents to assign tasks to their
          child(ren) on flexible, recurring schedules.

          While the backend system can support nearly any type of recurring schedule, we are going to focus on:
            - Once (no associated recurring rules, only start and end date set)
            - Daily {"validations":{},"rule_type":"IceCube::DailyRule","interval":1}
            - Weekly (on mon-fri) {"validations":{"day":[1,2,3,4,5]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}

        EOS
      end

      api :GET, "/v1/families/:family_id/todos/:todo_id/todo_schedules", "Get all todo schedules for todo"
      def index
        messages = init_messages
        begin
          @todo = Todo.find(params[:todo_id])
          @family = Family.find(params[:family_id])


          if @family && @todo && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)

            render :json => { :todo_schedules => @todo.todo_schedules.as_json, :messages => messages }, :status => 200
          else
            messages[:error] << "You are not authorized to do this"
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :GET, "/v1/families/:family_id/todos/:todo_id/todo_schedules/:todo_schedule_id", "Get a single todo schedule"
      def show
        messages = init_messages
        begin
          @todo = Todo.find(params[:todo_id])
          @family = Family.find(params[:family_id])
          @todo_schedule = @todo.todo_schedules.find(params[:id])


          if @family && @todo && @todo_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)

            render :json => { :todo_schedule => @todo_schedule.as_json, :messages => messages }, :status => 200
          else
            messages[:error] << "You are not authorized to do this"
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end


      api :POST, "/v1/families/:family_id/todos/:todo_id/todo_schedules", "Create a todo_schedule"
      param :member_id, Integer, desc: "The member id to assign the schedule to", required: true
      param :todo_id, Integer, desc: "The todo id associated with this schedule", required: true
      param :rules, Hash, desc: "The rules array in IceCube::Rule to_hash format", required: false
      param :start_date, String, desc: "The start date for this schedule (default: today)", required: false
      param :end_date, String, desc: "The end date for this schedule (default: never)", required: false
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @todo = @family.todos.find(params[:todo_id])
          start_date = params[:start_date] ? Chronic.parse(params[:start_date]) : nil
          end_date = params[:end_date] ? Chronic.parse(params[:end_date]) : nil
          if @family && @member && @todo && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            @todo_schedule = TodoSchedule.create(member_id: @member.id, todo_id: @todo.id, start_date: start_date, end_date: end_date )
            begin
              if params[:rules].is_a?(Array)
                params[:rules].each do |rule|
                  rule = IceCube::Rule.from_hash(rule)
                  rrule = @todo_schedule.schedule_rrules.build
                  rrule.rule = rule.to_yaml
                  rrule.save
                end
              end
              render :json => { :todo_schedule => @todo_schedule.as_json, :messages => messages }, :status => 200
            rescue
              messages[:error] << "Unable to parse rule"
              render :json => { :messages => messages }, :status => 400
            end
          else
            messages[:error] << "You are not authorized to do this"
            render :json => { :messages => messages }, :status => 403

          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :PATCH, "/v1/families/:family_id/todos/:todo_id/todo_schedules/:todo_schedule_id", "Update a todo_schedule rule end date"
      param :end_date, String, desc: "The end date for this schedule (default: never)", required: true
      def update
        messages = init_messages
        begin
          @todo_schedule = TodoSchedule.find(params[:id])
          @family = Family.find(params[:family_id])


          if @family && @todo_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            @todo_schedule.start_date = Chronic.parse(params[:start_date]) if params[:start_date]
            @todo_schedule.end_date = Chronic.parse(params[:end_date]) if params[:end_date]
            if @todo_schedule.save
              render :json => { :todo_schedule => @todo_schedule.as_json, :messages => messages }, :status => 200
            else
              messages.errors.concat @todo_schedule.errors.full_messages
              render :json => { :messages => messages }, :status => 400
            end

          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end


      api :DELETE, "/v1/families/:family_id/todos/:todo_id/todo_schedules/:todo_schedule_id", "Delete a todo_schedule rule"
      def destroy
        messages = init_messages
        begin
          @todo_schedule = TodoSchedule.find(params[:id])
          @family = Family.find(params[:family_id])


          if @family && @todo_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            if @todo_schedule.destroy
              render :json => { :todo_schedule => @todo_schedule.as_json, :messages => messages }, :status => 200
            else
              messages.errors.concat @todo_schedule.errors.full_messages
              render :json => { :messages => messages }, :status => 400
            end

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
