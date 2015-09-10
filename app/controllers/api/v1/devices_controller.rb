module Api
  module V1
    class DevicesController < ApiController

      skip_before_filter :restrict_api_access, only: [:deviceDidRegister, :status]

      resource_description do
        short 'API Devices'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized (API)'
        error code: 403, desc: 'Unauthorized for this request'
        error code: 400, desc: 'User input/param error for this request'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Devices
          The Devices API has two entry points: a global entery (/devices) and a family scope (/families/<family_id>/devices).

          The public entry is used explicitly for the integration with the Mobile Device Management functions: deviceDidRegister and updateDeviceStatus

        EOS
      end

      def_param_group :device do
        param :name, String, desc: "The friendly name of the device", required: true
        param :device_type_id, Integer, desc: "The ID of this device's type, see /device_types"
        param :family_id, Integer, desc: "The ID of the Family this device belongs to"
        param :management_id, Integer, desc: "Optionally define an ID of a parent device that manages this device (typically only used with Kudoso Plug devices)"
        param :primary_member_id, Integer, desc: "Optionally assign the device to specific family member"
        param :uuid, String, desc: "Readonly unique identifier for device (generated by Kudoso)"

      end

      api :POST, "/v1/devices/:uuid/deviceDidRegister", "Collects information from the MDM regarding device registration"
      param :udid, String, desc: "Unique identfier for device (generated by MDM)", required: true
      param :wifi_mac, String, desc: "The MAC address of the device's WiFi interface"
      param :os_version, String, desc: "The version number of the operating system on device (ie: 8.1.2)"
      param :build_version, String, desc: "The build version of the device (as reported by the MDM)"
      param :product_name, String, desc: "The product description with generation (ie: iPad5,1)"
      param :model_name, String, desc: "The model name of the device (ie: iPhone, iPod)"
      param :device_name, String, desc: "The device name as reported by the device"
      def deviceDidRegister
        messages = init_messages
        device = ApiDevice.find_by_device_token(params[:device_token])
        if device.nil?
          messages[:error] << 'Invalid Device Token'
          failure (messages)
          return
        else

          #binding.pry
          auth = request.headers["Signature"]
          if auth != Digest::MD5.hexdigest(request.body.read + device.device_token.reverse)
            messages[:error] << "Invalid Signature: #{request.body.read}"
            failure (messages)
            return
          end

          if device.expires_at.present? and device.expires_at < Date.today
            messages[:error] << 'Device/application access expired, please update your application code at your app store'
            failure(messages)
            return
          else
            messages[:warning] << "This application has been marked for end-of-life at #{device.expires_at.to_formatted_s(:long_ordinal)}.  Please update the application as soon as possible to avoid any problems with access." if  device.expires_at.present?

            begin
              @device = Device.find_by_uuid(params[:uuid])
              @device.udid = params[:udid] if params[:udid]
              @device.wifi_mac = params[:wifi_mac] if params[:wifi_mac]
              @device.os_version = params[:os_version] if params[:os_version]
              @device.build_version = params[:build_version] if params[:build_version]
              @device.product_name = params[:product_name] if params[:product_name]
              @device.device_type_id = DeviceType.find_or_create_by(name: params[:model_name]).id          if params[:model_name]
              @device.device_name = params[:device_name] if params[:device_name]

              if @device.save

                render :json => { :device => @device, :messages => messages }, :status => 200
              else
                messages[:error] << @device.errors.full_messages
                render :json => { :device => @device, :messages => messages }, :status => 400
              end



            rescue ActiveRecord::RecordNotFound
              messages[:error] << 'Device not found.'
              render :json => { :messages => messages }, :status => 404
            rescue
              messages[:error] << 'A server error occurred.'
              render :json => { :messages => messages }, :status => 500
            end
          end
        end

      end

      api :PATCH, "/v1/devices/:udid/status", "Updates state information from the MDM regarding device"
      param :reachable, [0, 1], desc: "1 = reachable, 0 = unreachable"
      param :lastReachedAt, Integer, desc: "last time (in epoch seconds) that the device was reached"
      param :commandExecuted, String, desc: "last command executed (only present if reachable==1"
      param :commandStatus, Integer, desc: "0 == success or error code"
      param :commandStatusMessage, String, desc: "Detailed message for the commandStatus"
      def status
        messages = init_messages
        device = ApiDevice.find_by_device_token(params[:device_token])
        if device.nil?
          messages[:error] << 'Invalid Device Token'
          failure (messages)
          return
        else

          #binding.pry
          auth = request.headers["Signature"]
          if auth != Digest::MD5.hexdigest(request.body.read + device.device_token.reverse)
            messages[:error] << "Invalid Signature: #{request.body.read}"
            failure (messages)
            return
          end

          if device.expires_at.present? and device.expires_at < Date.today
            messages[:error] << 'Device/application access expired, please update your application code at your app store'
            failure(messages)
            return
          else
            messages[:warning] << "This application has been marked for end-of-life at #{device.expires_at.to_formatted_s(:long_ordinal)}.  Please update the application as soon as possible to avoid any problems with access." if  device.expires_at.present?

            begin
              @device = Device.find_by_udid(params[:udid])

              if params[:lastReachedAt]
                if @device.update_attribute( :last_contact, Time.at(params[:lastReachedAt].to_i) )
                  messages[:info] << "Device last contacted at #{@device.last_contact}"
                else
                  messages[:error] << @device.errors.full_messages
                end
              end

              if params["commandExecuted"]
                @command = @device.last_command( params["commandExecuted"] )
                @command.executed = true
                @command.status = params["commandStatus"] if params["commandStatus"]
                @command.result = params["commandStatusMessage"] if params["commandStatusMessage"]
                if @command.save
                  messages[:info] << "Saved command to ID: #{@command.id}"
                else

                  messages[:error] << @command.errors.full_messages
                end

              end


              render :json => { :device => @device, :messages => messages }, :status => (messages[:error].length == 0) ? 200 : 400

            rescue ActiveRecord::RecordNotFound
              messages[:error] << 'Device not found.'
              render :json => { :messages => messages }, :status => 404
            rescue
              messages[:error] << 'A server error occurred.'
              render :json => { :messages => messages }, :status => 500
            end
          end
        end

      end

      api :GET, "/v1/families/:family_id/devices", "Retrieve all family devices"
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user && ( @current_user.admin? || @current_user.family == @family)
            @devices = @family.devices
            render :json => { :devices => @devices, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :GET, "/v1/families/:family_id/devices/:device_id", "Retrieve a specific device"
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            @device = @family.devices.find(params[:id])
            render :json => { :device => @device, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family or Member not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/families/:family_id/devices", "Create a new device for this family (authenticated user must be a parent), will check for a matching device and return it or create a new one"
      param_group :device
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            @device = Device.where(device_create_params.slice(:mac_address).merge(family_id: @family.id)).first
            @device ||= Device.create(device_create_params.merge(family_id: @family.id))
            if @device.valid?
              render :json => { :device => @device, :messages => messages }, :status => 200
            else
              messages[:error] << @device.errors.full_messages
              render :json => { :device => @device, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :PATCH, "/v1/families/:family_id/devices/:device_id", "Update a device (authenticated user must be a parent)"
      param_group :device
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            @device = @family.devices.find(params[:id])

            if @device.update_attributes(device_create_params.merge(family_id: @family.id))
              render :json => { :device => @device, :messages => messages }, :status => 200
            else
              messages[:error] << @member.errors.full_messages
              render :json => { :device => @device, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end


      end

      api :DELETE, "/v1/families/:family_id/devices/:device_id", "Delete a family device (authenticated user must be a parent)"
      param_group :device
      def destroy
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            @device = @family.devices.find(params[:id])
            if @device.destroy
              render :json => { :device => @device, :messages => messages }, :status => 200
            else
              messages[:error] << @member.errors.full_messages
              render :json => { :device => @device, :messages => messages }, :status => 400
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      api :POST, "/v1/devices/record", "API Used by Kudoso Routers to record a device seen on the router"
      param :router_mac_address, String, desc: 'The mac address of the Kudoso Router reporting the device', required: true
      param :ip, String, desc: 'The IP Address of the device being reported', required: true
      param :mac_address, String, desc: 'The MAC Address of the device being reported', required: true
      param :name, String, desc: 'The hostname of the device being reported', required: false
      def record
        messages = init_messages
        auth = request.headers["Signature"]
        router = Router.find_by(mac_address: params[:router_mac_address])
        if router.nil?
          messages[:error] << "Unknown Router"
          router_failure(messages)
          return
        end

        if auth != Digest::MD5.hexdigest(request.path + request.headers["Timestamp"] + router.secure_key)
          messages[:error] << "Invalid Signature"
          router_failure(messages)
          return
        end

        logger.info "A new device was registered: #{params.inspect}"


        render :json => { :messages => messages }, :status => 200
      end


      def failure(msg)
        logger.error "Devices API failure: #{msg.inspect}"
        render :json => { :messages => msg }, :status => 401
      end

      private


      # Never trust parameters from the scary internet, only allow the white list through.
      def device_create_params
        params.require(:device).permit(:name, :device_type_id, :primary_member_id, :os_version, :wifi_mac, :build_version, :product_name, :model_name, :mac_address)
      end


    end
  end
end
