class Users::SessionsController < Devise::SessionsController
  # def new
  #   super
  # end

  def create
    super
    cookies[:family_id] = current_user.member.family_id
    sign_in :member, current_user.member
  end
end
