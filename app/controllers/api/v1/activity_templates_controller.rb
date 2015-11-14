module Api
  module V1
    class ActivityTemplatesController < ApiController


      resource_description do
        short 'API ActivityTemplates'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Activity Templates
          Once authenticated, you can retrieve a Family's specific actvitity template infomation.

          Member object returns as JSON.

        EOS
      end


      api :GET, "/v1/families/:family_id/activity_templates", "Retrieve all Activity Templates"
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user && ( @current_user.admin? || @current_user.family == @family || @current_member.family == @family)
            render :json => { :activity_templates => @family.get_activity_templates.as_json, :messages => messages }, :status => 200
          else

            messages[:error] << 'Authorization failed'
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

    end

  end
end
