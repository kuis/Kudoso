# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :authorized?
  private
  def authorized?
    unless current_user.admin?
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end
end