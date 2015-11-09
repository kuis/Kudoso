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

    respond_to do |format|
      if @device_type.save
        format.html { redirect_to admin_device_types_url, notice: 'Device Type was successfully created.' }
        format.json { render :show, status: :created, location: @device_type }
      else
        format.html { render :new }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device_type.update(device_type_params)
        format.html { redirect_to admin_device_types_url, notice: 'Device Type was successfully updated.' }
        format.json { render :show, status: :ok, location: @device_type }
      else
        format.html { render :edit }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_device_types_url, notice: 'Device Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def device_type_params
      params.require(:device_type).permit(:name, :description, :os, :version, :icon)
    end
end
