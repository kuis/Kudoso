class Admin::ApiDevicesController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @api_devices = ApiDevice.all
    respond_with(@api_devices)
  end

  def show
    respond_with(@api_device)
  end

  def new
    @api_device = ApiDevice.new
    respond_with(@api_device)
  end

  def edit
  end

  def create
    @api_device = ApiDevice.new(api_device_params)
    @api_device.save
    respond_with([:admin, @api_device])
  end

  def update
    @api_device.update(api_device_params)
    respond_with([:admin, @api_device])
  end

  def destroy
    @api_device.destroy
    respond_with([:admin, @api_device])
  end

  private

    def api_device_params
      params.require(:api_device).permit(:device_token, :name, :expires_at)
    end
end
