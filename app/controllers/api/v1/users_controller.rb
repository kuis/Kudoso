module Api
  module V1
    class UsersController < ApiController
      skip_before_filter :restrict_api_access, only: :create

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
                render :json => { :user => @user, token: @user.get_api_key.access_token, :messages => messages }, :status => 200
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

      private


      # Never trust parameters from the scary internet, only allow the white list through.
      def user_create_params
        params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name, :email)
      end

    end

  end
end
