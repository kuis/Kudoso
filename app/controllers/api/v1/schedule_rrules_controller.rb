module Api
  module V1
    class ScheduleRrulesController < ApiController

      resource_description do
        short 'API Schedule Rrules (recurring rules)'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Schedule Recurring Rules

          While the backend system can support nearly any type of recurring schedule, we are going to focus on:
            - Daily {"validations":{},"rule_type":"IceCube::DailyRule","interval":1}
            - Weekly (on mon-fri) {"validations":{"day":[1,2,3,4,5]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}
          Note that the days of week is a zero based index starting with Sunday == 0
          This object is based on the ruby gem IceCube (https://github.com/seejohnrun/ice_cube)

        EOS
      end

      api :POST, "/v1/families/:family_id/todo_schedules/:todo_schedule_id/schedule_rrules", "Create a schedule_rrule"
      param :rule, Hash, desc: "The rule in IceCube::Rule to_hash format"
      def create
        messages = init_messages
        begin
          @todo_schedule = TodoSchedule.find(params[:todo_schedule_id])
          @family = Family.find(params[:family_id])

          if @family && @todo_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            begin
              rule = IceCube::Rule.from_hash(params[:rule])
              @schedule_rrule = @todo_schedule.schedule_rrules.build
              @schedule_rrule.rule=rule.to_yaml
              @schedule_rrule.save
              render :json => { :schedule_rrule => @schedule_rrule.as_json, :messages => messages }, :status => 200
            rescue
              messages[:error] << "Unable to parse rule"
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

      api :PATCH, "/v1/families/:family_id/todo_schedules/:todo_schedule_id/schedule_rrules/:schedule_rrule_id", "Update a schedule_rrule"
      param :rule, Hash, desc: "The rule in IceCube::Rule to_hash format"
      def update
        messages = init_messages
        begin
          @schedule_rrule = ScheduleRrule.find(params[:id])
          @family = Family.find(params[:family_id])

          if @family && @schedule_rrule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            begin
              rule = IceCube::Rule.from_hash(params[:rule])
              @schedule_rrule.rule=rule.to_yaml
              @schedule_rrule.save
              render :json => { :schedule_rrule => @schedule_rrule.as_json, :messages => messages }, :status => 200
            rescue
              messages[:error] << "Unable to parse rule"
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

      api :DELETE, "/v1/families/:family_id/todo_schedules/:todo_schedule_id/schedule_rrules/:schedule_rrule_id", "Delete a schedule_rrule"
      def destroy
        messages = init_messages
        begin
          @schedule_rrule = ScheduleRrule.find(params[:id])
          @family = Family.find(params[:family_id])

          if @family && @schedule_rrule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            if @schedule_rrule.destroy
              render :json => { :messages => messages }, :status => 200
            else
              messages[:error] << 'Unable to destroy record'
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
