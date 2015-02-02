class Members::SessionsController < Devise::SessionsController
  def new
    if cookies.signed[:kudoso_family].present? && cookies.signed[:kudoso_family] == params[:id].to_i
      logger.info "all good, proceeding!"
      super
    else
      flash[:alert] = 'Before you can login as a family member from this device, a full user account must first successfully login.'
      redirect_to new_user_session_path
    end

  end

  # def create
  #   super
  # end
end
