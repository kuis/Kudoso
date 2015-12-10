module Api
  module V1
    class DeviceTypesController < ApiController

      resource_description do
        short 'Default Device Types'
        formats ['json']
        api_version "v1"
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Avatars
          Will return a JSON array of all the default device types in the system
        EOS
      end

      api :GET, "/v1/device_types", "Get list of device types"
      def index
        messages = init_messages
        render :json => { device_types: DeviceType.all.as_json, messages: messages }, :status => 200
      end

    end
  end
end