module Api
  module V1
    class UsersController < ApiController
      skip_before_filter :restrict_api_access, only: [:create, :reset_password]

      resource_description do
        short 'Users'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Users
          Users in Kudoso are the main authentication / billing object.  Users have families and then members belong to families.
          Thus, an Kudoso account has one and only one USER.

        EOS
      end

      api :GET, "/v1/users/:user_id", "Retrieve a specific user account (only for the signed in user)"
      def show
        messages = init_messages
        begin
          @user = User.find(params[:id])
          if @current_user.try(:admin) || (@current_user == @user )
            render :json => { :user => @user, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'User not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/users", "Create a new user account"
      param :password, String, desc: 'The password string for the user (7 char min)', required: true
      param :password_confirmation, String, desc: 'The password confirmation string for the user (must match password)', required: true
      param :first_name, String, desc: 'The first name of the user', required: true
      param :last_name, String, desc: 'The last name of the user', required: true
      param :email, String, desc: 'The email address of the user', required: true
      def create
        messages = init_messages
        begin
          device = ApiDevice.find_by_device_token(params[:device_token])
          if device.nil?
            messages[:error] << 'Invalid Device Token'
            failure (messages)
            return
          else
            if device.expires_at.present? and device.expires_at < Date.today
              messages[:error] << 'Device/application access expired, please update your application code at your app store'
              failure(messages)
              return
            else
              messages[:warning] << "This application has been marked for end-of-life at #{device.expires_at.to_formatted_s(:long_ordinal)}.  Please update the application as soon as possible to avoid any problems with access." if  device.expires_at.present?

              @user = User.new(user_create_params)
              if @user.save
                render :json => { user:      @user,
                                  member:    @user.member,
                                  family:    @user.family,
                                  token:     @user.get_api_key.access_token,
                                  :messages => messages }, :status => 200
              else
                messages[:error] << @user.errors.full_messages
                render :json => { :user => @user, :messages => messages }, :status => 400
              end
            end
          end

        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/users/reset_password", "Issue a password reset request for the specified account"
      param :email, String, desc: 'The email address of the requested account', required: true
      def reset_password
        messages = init_messages
        user = User.find_by_email(params[:email])
        if user.present?
          user.send_reset_password_instructions
          render :json => { :messages => messages }
        else
          messages[:error] << 'Email not found'
          render :json => { :messages => messages }, :status => 409
        end
      end

      private

      def failure(msg)
        render :json => { :messages => msg }, :status => 401
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_create_params
        params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name, :email)
      end

    end

  end
end
