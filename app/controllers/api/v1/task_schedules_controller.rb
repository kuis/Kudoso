module Api
  module V1
    class TaskSchedulesController < ApiController

      resource_description do
        short 'API Task Schedules (also know as Task Schedules)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Task Schedules (Task Schedules)
          Tasks are parent directed activities, the task schedules allow parents to assign tasks to their
          child(ren) on flexible, recurring schedules.

          While the backend system can support nearly any type of recurring schedule, we are going to focus on:
            - Once (no associated recurring rules, only start and end date set)
            - Daily {"validations":{},"rule_type":"IceCube::DailyRule","interval":1}
            - Weekly (on mon-fri) {"validations":{"day":[1,2,3,4,5]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}

        EOS
      end

      api :GET, "/v1/families/:family_id/tasks/:task_id/task_schedules", "Get all task schedules for task"
      def index
        messages = init_messages
        begin
          @task = Task.find(params[:task_id])
          @family = Family.find(params[:family_id])


          if @family && @task && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)

            render :json => { :task_schedules => @task.task_schedules.as_json, :messages => messages }, :status => 200
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

      api :GET, "/v1/families/:family_id/tasks/:task_id/task_schedules/:task_schedule_id", "Get a single task schedule"
      def show
        messages = init_messages
        begin
          @task = Task.find(params[:task_id])
          @family = Family.find(params[:family_id])
          @task_schedule = @task.task_schedules.find(params[:id])


          if @family && @task && @task_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)

            render :json => { :task_schedule => @task_schedule.as_json, :messages => messages }, :status => 200
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


      api :POST, "/v1/families/:family_id/tasks/:task_id/task_schedules", "Create a task_schedule"
      param :member_id, Integer, desc: "The member id to assign the schedule to", required: true
      param :task_id, Integer, desc: "The task id associated with this schedule", required: true
      param :rules, Array, desc: "The rules array, an array of rule hashes in IceCube::Rule to_hash format.  EX: [ {\"validations\":{\"day\":[1,2,3,4,5]},\"rule_type\":\"IceCube::WeeklyRule\",\"interval\":1,\"week_start\":0} ]" , required: false
      param :start_date, String, desc: "The start date for this schedule (default: today)", required: false
      param :end_date, String, desc: "The end date for this schedule (default: never)", required: false
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @task = @family.tasks.find(params[:task_id])
          start_date = params[:start_date] ? Chronic.parse(params[:start_date]) : nil
          end_date = params[:end_date] ? Chronic.parse(params[:end_date]) : nil
          if @family && @member && @task && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            @task_schedule = TaskSchedule.create(member_id: @member.id, task_id: @task.id, start_date: start_date, end_date: end_date )
            begin
              if params[:rules].is_a?(Array)
                params[:rules].each do |rule|
                  rule = IceCube::Rule.from_hash(rule)
                  rrule = @task_schedule.schedule_rrules.build
                  rrule.rule = rule.to_yaml
                  rrule.save
                end
              end
              render :json => { :task_schedule => @task_schedule.as_json, :messages => messages }, :status => 200
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

      api :PATCH, "/v1/families/:family_id/tasks/:task_id/task_schedules/:task_schedule_id", "Update a task_schedule rule end date"
      param :end_date, String, desc: "The end date for this schedule (default: never)", required: true
      def update
        messages = init_messages
        begin
          @task_schedule = TaskSchedule.find(params[:id])
          @family = Family.find(params[:family_id])


          if @family && @task_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            @task_schedule.start_date = Chronic.parse(params[:start_date]) if params[:start_date]
            @task_schedule.end_date = Chronic.parse(params[:end_date]) if params[:end_date]
            if @task_schedule.save
              render :json => { :task_schedule => @task_schedule.as_json, :messages => messages }, :status => 200
            else
              messages.errors.concat @task_schedule.errors.full_messages
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


      api :DELETE, "/v1/families/:family_id/tasks/:task_id/task_schedules/:task_schedule_id", "Delete a task_schedule rule"
      def destroy
        messages = init_messages
        begin
          @task_schedule = TaskSchedule.find(params[:id])
          @family = Family.find(params[:family_id])


          if @family && @task_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            if @task_schedule.destroy
              render :json => { :task_schedule => @task_schedule.as_json, :messages => messages }, :status => 200
            else
              messages.errors.concat @task_schedule.errors.full_messages
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
