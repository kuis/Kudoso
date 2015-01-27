class Members::SessionsController < Devise::SessionsController
  def new
    puts "New member session with cookie: #{cookies[:family_id]}"
    if cookies[:family_id].present? && cookies[:family_id] == params[:id]
      logger.info "all good, proceeding!"
      super
    else
      flash[:notice] = 'Before you can login as a family member from this device, a full user account must first successfully login.'
      redirect_to new_user_session_path
    end

  end

  # def create
  #   super
  # end
end
