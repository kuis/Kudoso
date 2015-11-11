module Api
  module V1
    class PlugsController < ApiController

      skip_before_filter :restrict_api_access

      api :POST, "/v1/plugs", "Register this plug"
      param :mac, String, desc: 'The mac address of this plug', required: true
      def create
        #
        # This method if the "registration" of a router with the system.  This should only be called once
        # to allow for the return of the router.secure_key attribute used in signatures
        #
        messages = init_messages
        auth = request.headers["Signature"]
        logger.debug "#{request.path} + #{request.headers["Timestamp"]} + #{Digest::MD5.hexdigest(request.path + request.headers["Timestamp"])}"
        if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"])
          messages[:error] << "Invalid Signature"
          plug_failure(messages)
          return
        end

        if request.headers["Timestamp"].to_i < 5.minutes.ago.utc.to_i ||  request.headers["Timestamp"].to_i > Time.now.utc.to_i
          messages[:error] << "Invalid Timestamp"
          plug_failure(messages)
          return
        end

        if params[:mac].blank?
          messages[:error] << "Invalid Params, must send MAC Address"
          plug_failure(messages)
          return
        end

        begin
          @plug = Plug.find_by_mac_address(params[:mac].downcase)

          if @plug.nil?
            messages[:error] << "Unknown plug"
            plug_failure(messages, 404)
            return
          end

          if @plug.registered
            messages[:error] << "Plug was previously registered"
            plug_failure(messages, 400)
            return
          end

          @plug.update_attribute(:registered, true)
          render :json => { plug: @plug, :messages => messages }, :status => 200

        rescue ActiveRecord::RecordNotFound
          messages[:error] << "Unknown plug"
          plug_failure(messages, 404)
          return
        rescue
          messages[:error] << "Unknown error"
          plug_failure(messages, 400)
          return
        end



      end

      api :GET, "/v1/plugs/:id", "Returns current information about the plug"
      def show
        messages = init_messages
        begin
          @plug = Plug.find(params[:id])
          #binding.pry
          auth = request.headers["Signature"]
          if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"] + @plug.secure_key)
            messages[:error] << "Invalid Signature"
            plug_failure(messages)
            return
          else
            if !@plug.registered
              messages[:error] << "Plug is not registered, register first"
              plug_failure(messages, 403)
              return
            end
            @plug.touch(request.remote_ip.to_s)
          end

          render :json => { plug: @plug.as_json({except: :secure_key}), :messages => messages }, :status => 200
        rescue
          messages[:error] << "Unknown error"
          plug_failure(messages, 400)
          return
        end
      end   #show



      def plug_failure(msg, status = 401)
        logger.error "PLUGS API failure: #{msg.inspect}"
        render :json => { :messages => msg }, :status => status
      end

    end
  end
end
