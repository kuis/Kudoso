module Api
  module V1
    class SessionsController < ApiController
      skip_before_filter :restrict_api_access

      def create
        messages = init_messages
        # api_session = ApiSession.create(url: request.url, params: params, remote_ip: request.remote_ip.inspect, query_string: request.query_string.inspect, method: request.method.inspect, location: params[:location])
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
            # begin
            if (params[:family_id].present? && params[:username].present?) || params[:email] || params[:provider].present?
              params[:provider] ||= 'identity'
              if params[:provider] == 'identity'

                if params[:family_id].present? && params[:username].present?
                  family = Family.find(params[:family_id])
                  if family
                    member = family.members.where(username: params[:username]).first
                    if member
                      if member.valid_password?(params[:password])
                        render :json => { member:    member,
                                          token:     member.get_api_key.access_token,
                                          messages:  messages }, :status => 200
                        return
                      else

                        messages[:error] << 'Invalid password!'
                        failure(messages)
                        return
                      end
                    else
                      messages[:error] << 'User not found in family specified'
                      failure(messages)
                      return
                    end
                  else
                    messages[:error] << 'Invalid family specified'
                    failure(messages)
                    return
                  end

                end
                if params[:email].present?

                  user = User.find_by_email(params[:email])
                  if user
                    if user.valid_password?(params[:password])
                      render :json => { user:      user,
                                        member:    user.member,
                                        token:     user.get_api_key.access_token,
                                        messages:  messages }, :status => 200
                      return
                    else
                      messages[:error] << 'Invalid password!'
                      failure(messages)
                      return
                    end
                  else
                    messages[:error] << 'Email not found!'
                    failure(messages)
                    return
                  end
                end

              end
              if params[:provider] == 'facebook'
                token = params[:token]

                fb_user = FbGraph::User.me(token)
                fb_user = fb_user.fetch

                user = User.create_with_facebook(fb_user)
              end
            else
              logger.error "Invalid API parameters: #{params.to_yaml}"
              messages[:error] << 'Invalid API Parameters!'
              failure(messages)
              return
            end

          end

        end

      end

      def failure(msg)
        render :json => { :messages => msg }, :status => 401
      end

      def destroy
        messages = init_messages
        api_key = params[:id]
        key = ApiKey.find_by_access_token(api_key)
        key.update_attribute(:expires_at, DateTime.now)
        messages[:info] << 'Session was successfully destroyed.'
        render :json => { messages: messages }, status: 200
      end

    end
  end
end