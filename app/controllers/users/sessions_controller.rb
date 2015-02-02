class Users::SessionsController < Devise::SessionsController
  # def new
  #   super
  # end

  def create
    super
    unless current_user.nil? || current_user.admin?
      cookies.signed[:kudoso_family] = { :value => current_user.member.family_id, :expires => 50.years.from_now }
      sign_in :member, current_user.member
    end

  end
end
