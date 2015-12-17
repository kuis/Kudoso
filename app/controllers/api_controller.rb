class ApiController < ApplicationController
  skip_before_filter :restrict_access
  before_filter :restrict_api_access
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session
  respond_to :json

  rescue_from ::Exception, with: :error_occurred
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found(exception)
    logger.info "NotFound Error: #{exception.message}"
    logger.info exception.backtrace

    messages = init_messages
    #binding.pry
    object = exception.message.match /Couldn't find ([\w]+) with 'id'=([\d]+)/
    messages[:error] << "#{object[1]} #{object[2]} not found."
    render json: { :messages => messages }, status: 404
    return
  end

  def error_occurred(exception)
    logger.info "System Error: #{exception.message}"
    logger.info exception.backtrace

    messages = init_messages
    messages[:error] << 'A server error occurred.'
    render json: { :messages => messages }, status: 500
    return
  end

  def restrict_api_access
    api_key = nil
    authenticate_or_request_with_http_token do |token, options|
      begin
        logger.debug "API session key: #{token}"
        api_key = ApiKey.includes(:member).find_by_access_token(token)
        if api_key and api_key.expires_at <= DateTime.now
          api_key = nil
        end
        api_key
      rescue
        false
      end

    end
    if api_key.present? && (api_key.user.present? || api_key.member.present?)
      api_key.update_expiration!
      @current_member = api_key.try(:member)
      @current_user = api_key.try(:user)
      @current_member ||= @current_user.try(:member)
    else
      logger.debug "API Authentication failed: #{api_key.inspect}"
      api_key.try(:destroy)
      head :unauthorized
    end
  end




end