module Api
  module V1
    class ActivitiesController < ApiController
      # This controller is only callable through the family and member
      # /api/v1/family/:family_id/members/:member_id/activities

      resource_description do
        short 'API activities '
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Actvities
          Activities are ALL activities (screen time and learning) that a child may engage in

        EOS
      end



      api :GET, "/v1/families/:family_id/members/:member_id/activities", "Retrieve all activities for a member (default: today's activities)"
      param :start_date, Date, desc: "Optionnaly specify a start date"
      param :end_date, Date, desc: "Optionnaly specify an end date"
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == params[:member_id].to_i
            @member = @family.members.find(params[:member_id])
            params[:start_date] ||= Date.today
            params[:end_date] ||= Date.today
            @activities = @member.activities
            if params["start_date"] && params["end_date"]
              begin
                start_time = Chronic.parse(params["start_date"])
                end_time =  Chronic.parse(params["end_date"])
                @activities = @member.activities.where(created_at: start_time.beginning_of_day..end_time.end_of_day)
              rescue
                logger.error "Invalid start or end time for activities"
              end
            end
            logger.debug "Returning JSON: #{@activities.as_json}"
            render :json => { activities: @activities.as_json, :messages => messages }, :status => 200
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

      api :GET, "/v1/families/:family_id/members/:member_id/activities/:activity_id", "Retrieve a activity for a member"
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @activity = @member.activities.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == @my_todo.member_id
            render :json => { :activity => @activity.as_json, :messages => messages }, :status => 200
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

      api :POST, "/v1/families/:family_id/members/:member_id/activities", "Create a new activity"
      param :activity_template_id, Integer, desc: "The ID for the activity template associated with this activity", required: true
      param :devices, Array, desc: "An array of the IDs for the device(s) used with this activity", required: true
      param :content_id, Integer, desc: "The ID for the content associated with this activity (if applicable)", required: false
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member
            @activity_template = ActivityTemplate.find(params["activity_template_id"])

            @devices = Device.where(id:  params["devices"] )
            @activity = @member.new_activity(@activity_template, @devices)
            if @activity.valid?
              render :json => { :activity => @activity.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @activity.errors.full_messages
              render :json => { :activity => @activity.as_json, :messages => messages }, :status => 400
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

      api :PATCH, "/v1/families/:family_id/members/:member_id/activities/:activity_id", "Start or Stop an activity, or change the associations"
      param :start, [true], desc: 'Include the start param to start the activity', required: false
      param :stop, [true], desc: 'Include the stop param to stop the activity', required: false
      param :content_id, Integer, desc: "The ID for the content associated with this activity (if applicable)", required: false
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @activity = @member.activities.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member

            @activity.content_id = params[:content_id].to_i if params[:content_id]
            @activity.save if @activity.changed?
            valid = @activity.valid?
            if params[:start]
              @activity.start!
              if @activity.start_time.nil?
                @activity.errors.add(:start, 'failed')
                valid = false
              end
            end

            if params[:stop]
              @activity.stop!
              if @activity.end_time.nil?
                @activity.errors.add(:start, 'failed')
                valid = false
              end
            end

            if valid
              render :json => { :activity => @activity.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @activity.errors.full_messages
              render :json => { :activity => @activity.as_json, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end
        rescue Activity::ScreenTimeExceeded
          messages[:error] << 'Cannot start activity, allowed screen time exceeded.'
          render :json => { :messages => messages }, :status => 400
        rescue Activity::AlreadyStarted
          messages[:error] << 'Cannot start activity, it was previously started.'
          render :json => { :messages => messages }, :status => 400
        rescue Activity::TodosIncomplete
          messages[:error] << 'Cannot start activity, required tasks are not yet complete.'
          render :json => { :messages => messages }, :status => 400
        rescue Activity::ScreenTimeRestricted
          messages[:error] << 'Cannot start activity, screen time schedule is currently restricted.'
          render :json => { :messages => messages }, :status => 400
        rescue Activity::DeviceInUse
          messages[:error] << 'Cannot start activity, device is currently in use.'
          render :json => { :messages => messages }, :status => 400
        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end




    end

  end
end
