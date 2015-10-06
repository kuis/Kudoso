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
          @router = Router.find_or_create_by(mac_address: params[:mac].downcase)
          if @router.family.nil? || !@router.family.active?
            messages[:error] << "Router is not assigned to an active account, please contact Kudoso support."
            router_failure(messages, 400)
            return
          end


          if @router.registered
            logger.info "Router #{@router.id} #{@router.mac_address} previously registered, regenerating secure key"
            messages[:warning] << "Router was previously registered, generating new secure key"
            @router.generate_secure_key

          end

          @router.registered = true
          if @router.save
            render :json => { router: @router, latest_firmware: @router.latest_firmware.as_json(methods: :url), :messages => messages }, :status => 200
          else
            messages[:error] << @router.errors.full_messages
            render :json => { :messages => messages }, :status => 400
          end


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
        begin
          @router = Router.find(params[:id])
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
            @router.touch(request.remote_ip.to_s)
          end

          render :json => { router: @router.as_json({except: :secure_key}), latest_firmware: @router.latest_firmware.as_json(methods: :url), :messages => messages }, :status => 200
        rescue
          messages[:error] << "Unknown error"
          router_failure(messages, 500)
          return
        end
      end   #show

      api :GET, "/v1/routers/:id/devices", "Returns all devices and their status"
      def devices
        messages = init_messages
        begin
          @router = Router.find(params[:id])
          #binding.pry
          auth = request.headers["Signature"]
          if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"] + @router.secure_key)
            messages[:error] << "Invalid Signature"
            router_failure(messages)
            return
          end
          time_delta = (Time.now.utc.to_i - request.headers["Timestamp"].to_i )
          if  time_delta < 0 || time_delta > (60*5)  # within 5 minutes
            messages[:error] << "Invalid Timestamp"
            failure(messages)
            return
          end
          if !@router.registered
            messages[:error] << "Router is not registered, register first"
            router_failure(messages, 403)
            return
          end
          @router.touch(request.remote_ip.to_s)

          @devices = @router.family.devices
          render :json => { devices: @devices.as_json(methods: :activity_end_time), :messages => messages }, :status => 200
        rescue
          messages[:error] << "Unknown error"
          router_failure(messages, 500)
          return
        end
      end   # devices

      api :POST, "/v1/routers/:id/device", "Register a device"
      param :mac, String, desc: 'The MAC Address of the device (12:34:56:ab:cd:ef)', required: true
      param :ip, String, desc: 'The IP Address of the device (192.168.2.3)', required: false
      param :name, String, desc: 'The Nmae of the device (192.168.2.3)', required: false
      def device
        messages = init_messages
        begin
          @router = Router.find(params[:id])
          #binding.pry
          auth = request.headers["Signature"]
          if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"] + @router.secure_key)
            messages[:error] << "Invalid Signature"
            router_failure(messages)
            return
          end
          time_delta = (Time.now.utc.to_i - request.headers["Timestamp"].to_i )
          if  time_delta < 0 || time_delta > (60*5)  # within 5 minutes
            messages[:error] << "Invalid Timestamp"
            router_failure(messages)
            return
          end
          if !@router.registered
            messages[:error] << "Router is not registered, register first"
            router_failure(messages, 403)
            return
          end
          @router.touch(request.remote_ip.to_s)
          @device = Device.find_or_create_by(mac_address: params[:mac].downcase)
          @device.family_id = @router.family_id
          @device.router_id = @router.id
          @device.last_ip = params[:ip]
          if @device.name.nil? && @device.mac_address.present?
            @device.name = @device.mac_address
          end
          # intentionally ignoring params[:name] for now
          if @device.save
            render :json => { device: @device.as_json(methods: :activity_end_time), :messages => messages }, :status => 200
          else
            logger.info @device.errors.full_messages
            messages[:error] << @device.errors.full_messages
            render :json => { device: @device.as_json(methods: :activity_end_time), :messages => messages }, :status => 400
          end

        rescue
          messages[:error] << "Unknown error"
          router_failure(messages, 500)
          return
        end
      end   # devices


      def router_failure(msg, status = 401)
        logger.error "ROUTERS API failure: #{msg.inspect}"
        render :json => { :messages => msg }, :status => status
      end

    end
  end
end
