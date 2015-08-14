module Api
  module V1
    class RoutersController < ApiController

      skip_before_filter :restrict_api_access

      api :POST, "/v1/routers", "Register this router"
      param :mac, String, desc: 'The mac address of this router', required: true
      def create
        #
        # This method if the "registration" of a router with the system.  This should only be called once
        # to allow for the return of the router.secure_key attribute used in signatures
        #
        messages = init_messages
        auth = request.headers["Signature"]
        if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"])
          messages[:error] << "Invalid Signature"
          router_failure(messages)
          return
        end

        if params[:mac].blank?
          messages[:error] << "Invalid Params, must send MAC Address"
          router_failure(messages)
          return
        end

        begin
          @router = Router.find_by_mac_address(params[:mac].downcase)
          if @router.family.nil? || !@router.family.active?
            messages[:error] << "Router is not assigned to an active account, please contact Kudoso support."
            router_failure(messages, 400)
            return
          end


          if @router.registered
            messages[:error] << "Router was previously registered"
            router_failure(messages, 400)
            return
          end

          @router.update_attribute(:registered, true)
          render :json => { router: @router, latest_firmware: @router.latest_firmware, :messages => messages }, :status => 200

        rescue ActiveRecord::RecordNotFound
          messages[:error] << "Unknown router"
          router_failure(messages, 404)
          return
        rescue
          messages[:error] << "Unknown error"
          router_failure(messages, 400)
          return
        end



      end

      api :GET, "/v1/routers/:id", "Returns current information about the router"
      def show
        messages = init_messages

        @router = Router.find(:id)
        #binding.pry
        auth = request.headers["Signature"]
        if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"] + @router.secure_key)
          messages[:error] << "Invalid Signature"
          router_failure(messages)
          return
        else
          if !@router.registered
            messages[:error] << "Router is not registered, register first"
            router_failure(messages, 403)
            return
          end
          @router.touch(request)
        end

        render :json => { router: @router, latest_firmware: @router.latest_firmware, :messages => msg }, :status => 200

      end   #show



      def router_failure(msg, status = 401)
        logger.error "ROUTERS API failure: #{msg.inspect}"
        render :json => { :messages => msg }, :status => status
      end

    end
  end
end
