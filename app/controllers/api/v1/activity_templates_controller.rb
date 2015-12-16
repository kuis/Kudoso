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
          Once authenticated, you can retrieve a Family's specific actvitity template information.

          Member object returns as JSON.

        EOS
      end


      api :GET, "/v1/families/:family_id/activity_templates", "Retrieve all Activity Templates"
      def index
        messages = init_messages
        @family = Family.find(params[:family_id])
        if @current_user && ( @current_user.admin? || @current_user.family == @family || @current_member.family == @family)
          render :json => { :activity_templates => @family.get_activity_templates.as_json, :messages => messages }, :status => 200
        else
          messages[:error] << 'Authorization failed'
          render :json => { :messages => messages }, :status => 403
        end
      end

      api :GET, "/v1/families/:family_id/activity_templates/:activity_template_id", "Retrieve all Activity Templates"
      def show
        messages = init_messages
        @family = Family.find(params[:family_id])
        @activity_template = ActivityTemplate.find(params[:id])
        if @current_user && ( @current_user.admin? || @current_user.family == @family || @current_member.family == @family)
          render :json => { :activity_template => @activity_template.as_json, :messages => messages }, :status => 200
        else
          messages[:error] << 'Authorization failed'
          render :json => { :messages => messages }, :status => 403
        end
      end

    end

  end
end
