class ApiController < ApplicationController
  before_filter :restrict_api_access
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def restrict_api_access
    api_key = nil
    authenticate_or_request_with_http_token do |token, options|
      begin
        api_key = ApiKey.includes(:member).find_by_access_token(token)
        if api_key and api_key.expires_at <= DateTime.now
          api_key = nil
        else
          api_session = ApiSession.create(api_key_id: api_key.id, url: request.url, params: params, remote_ip: request.remote_ip.inspect, query_string: request.query_string.inspect, method: request.method.inspect)
        end
        api_key
      rescue
        false
      end

    end
    if api_key.present? and api_key.user.present?
      api_key.update_expiration!
      @current_user = api_key.user
      if params[:location]
        Delayed::Job.enqueue LocationJob.new(@current_user.id,params[:location],true) #this preloads the location cache for us
      end
    else
      api_key.destroy unless api_key.nil?
      head :unauthorized
    end
  end

  def init_messages
    messages = Hash.new
    messages[:info] = Array.new
    messages[:warning] = Array.new
    messages[:error] = Array.new
    return messages
  end
end