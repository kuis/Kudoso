class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :restrict_access

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter :set_time_zone

  helper_method :format_counter
  helper_method :format_counter_min

  def after_sign_in_path_for(resource)
    if resource.try(:admin)
      admin_families_path
    else
      if resource.wizard_step
        '/wizard'
      else
        request.env['omniauth.origin'] || stored_location_for(resource) || family_path(resource.family)
      end
    end
  end

  def after_sign_up_path_for(resource)
    if resource.wizard_step
      '/wizard'
    else
      families_path
    end
  end

  def format_counter(seconds)
    sec = seconds % 60
    min = (seconds/60).floor
    hours = (min/60).floor
    if hours > 0
      min = min - (hours * 60)
      "#{hours}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
    else
      "#{min}:#{sprintf('%02d', sec)}"
    end
  end
  def format_counter_min(seconds)
    sec = seconds % 60
    min = (seconds/60).ceil
    hours = (min/60).floor
    if hours > 0
      min = min - (hours * 60)
      "#{hours}:#{sprintf('%02d', min)}"
    else
      "00:#{min}"
    end
  end

  # Authentication
  rescue_from CanCan::AccessDenied do |exception|
    if member_signed_in?
      Rails.logger.info "Access denied for member: #{current_member.id}"
    else
      Rails.logger.info "Access denied for anonymous member"
    end
    message = member_signed_in? ? 'You are not authorized to do that!' : 'You must be logged in to do that.'

    flash[:error] = message
    redirect_to (member_signed_in? ? [current_member.family, current_member] : new_user_session_path) #and return
  end

  rescue_from JSON::ParserError do |ex|
    messages = init_messages
    messages[:error] << 'Error parsing JSON'
    render :json => { :messages => messages }, :status => 400
  end

  rescue_from ActionController::RoutingError do |ex|
    messages = init_messages
    messages[:error] << 'ActionController::RoutingError'
    respond_to do |format|
      format.json { render :json => { messages: messages }, :status => :not_found }
      format.html { render file: 'public/404.html' }
    end
  end

  def current_ability
    if member_signed_in?
      @current_ability ||= Ability.new(current_member)
    else
      @current_ability ||= Ability.new(current_user)
    end
  end

  def init_messages
    messages = Hash.new
    messages[:info] = Array.new
    messages[:warning] = Array.new
    messages[:error] = Array.new
    return messages
  end

  def cities
    render json: CS.cities(params[:state], :us).to_json
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :username, :password, :password_confirmation, :first_name, :last_name, :parent, :family_id) }
  end

  private

  def set_time_zone
    if current_member && current_member.family && current_member.family.timezone
      Time.zone = ActiveSupport::TimeZone[current_member.family.timezone]
      logger.info "Set timezone to #{Time.zone}"
    end
  end

  def restrict_access
    logger.info "Restricting access: #{request.path}"
    if Rails.env.staging? && !request.path.starts_with?('/stripe/events')
      authenticate_or_request_with_http_basic do |username, password|
        username == "kudoso" && password == "Launching2015!"
      end
    end
  end

  def parse_image_data(image_data)
    logger.info "Parsing image data..."
    data = StringIO.new(Base64.decode64(image_data["content"]))
    data.class.class_eval {attr_accessor :original_filename, :content_type}
    data.original_filename = Time.now.to_i.to_s + "." + image_data['content-type'].split('/')[1]
    data.content_type = image_data['content-type']
    return data
  end



end
