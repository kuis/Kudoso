class Admin::DeviceTypesController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @device_types = DeviceType.all
    respond_with(@device_types)
  end

  def show
    respond_with(@device_type)
  end

  def new
    @device_type = DeviceType.new
    respond_with(@device_type)
  end

  def edit
  end

  def create
    @device_type = DeviceType.new(device_type_params)
    @device_type.save
    respond_with(@device_type)
  end

  def update
    @device_type.update(device_type_params)
    respond_with(@device_type)
  end

  def destroy
    @device_type.destroy
    respond_with(@device_type)
  end

  private

    def device_type_params
      params.require(:device_type).permit(:name, :description, :os, :version)
    end
end
