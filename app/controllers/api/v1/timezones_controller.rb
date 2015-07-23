module Api
  module V1
    class TimezonesController < ApiController
      skip_before_filter :restrict_api_access

      resource_description do
        short 'API Timezones'
        formats ['json']
        api_version "v1"
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Timezones
          Will return a JSON object of all time zone display names and values for selection in 3rd party apps
        EOS
      end

      api :GET, "/v1/timezones", "Get list of supported timezones"
      def index
        render :json => ActiveSupport::TimeZone.us_zones.collect{|tz| tz.name }.as_json, :status => 200
      end

    end
  end
end