class users::sessionsController < Devise::sessionsController
  # def new
  #   super
  # end

  def create
    super
    sign_in :member, current_user.member
  end
end
