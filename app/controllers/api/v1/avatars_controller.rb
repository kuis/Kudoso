module Api
  module V1
    class AvatarsController < ApiController

      resource_description do
        short 'Default Avatars'
        formats ['json']
        api_version "v1"
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Avatars
          Will return a JSON array of all the default avatars in the system
        EOS
      end

      api :GET, "/v1/avatars", "Get list of avatars"
      def index
        messages = init_messages
        render :json => { avatars: Avatar.all, messages: messages }, :status => 200
      end

    end
  end
end