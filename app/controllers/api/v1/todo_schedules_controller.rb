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
            - Once
            - Daily
            - Weekly

        EOS
      end

      api :PATCH, "/v1/families/:family_id/todo_schedules/:todo_schedule_id", "Update a todo_schedule rule"
      param :rules, Hash, desc: "The rules array in IceCube::Rule to_hash format"
      def update
        messages = init_messages
        begin
          @todo_schedule = TodoTemplate.find(params[:id])
          @family = Family.find(params[:family_id])

          if @family && @todo_schedule && @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent?)
            begin
              rule = IceCube::Rule.from_hash(params[:rule])
              @todo_schedule
              render :json => { :todo_schedule => @todo_schedule.as_json, :messages => messages }, :status => 200
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



    end
  end
end
