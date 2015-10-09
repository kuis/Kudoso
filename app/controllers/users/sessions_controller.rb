class Users::SessionsController < Devise::SessionsController
  prepend_before_filter :verify_user, only: [:destroy]

  def create
    super
    unless current_user.nil? || current_user.admin?
      cookies.signed[:kudoso_family] = { :value => current_user.member.family_id, :expires => 50.years.from_now }
      cookies.signed[:kudoso_family_key] = { :value => current_user.member.family.secure_key, :expires => 50.years.from_now }
      sign_in :member, current_user.member
    end

  end

  private
  ## This method intercepts SessionsController#destroy action
  ## If a signed in user tries to sign out, it allows the user to sign out
  ## If a signed out user tries to sign out again, it redirects them to sign in page
  def verify_user
    ## redirect to appropriate path
    redirect_to new_user_session_path, notice: 'You have already signed out. Please sign in again.' and return unless user_signed_in?
  end
end
