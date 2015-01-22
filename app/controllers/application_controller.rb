class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  helper_method :format_counter

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :parent, :family_id) }
  end




end
