module Api
  module V1
    class ThemesController < ApiController

      resource_description do
        short 'Default Themes'
        formats ['json']
        api_version "v1"
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Avatars
          Will return a JSON array of all the default themes in the system
        EOS
      end

      api :GET, "/v1/themes", "Get list of themes"
      def index
        messages = init_messages
        render :json => { avatars: Theme.all, messages: messages }, :status => 200
      end

    end
  end
end