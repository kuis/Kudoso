class DevicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :family
  load_and_authorize_resource :device, through: :family

  respond_to :html

  def index
    @devices = Device.all
    respond_with(@devices)
  end

  def show
    respond_with(@device)
  end

  def new
    @device = Device.new
    respond_with(@device)
  end

  def edit
  end

  def create
    params[:device][:family_id] = @family.id
    @device = Device.new(device_params)
    @device.save
    respond_with(@family,@device)
  end

  def update
    params[:device][:family_id] = @family.id
    @device.update(device_params)
    respond_with(@family,@device)
  end

  def destroy
    @device.destroy
    respond_with(@family,@device)
  end

  private


    def device_params
      params.require(:device).permit(:name, :device_type_id, :family_id, :managed, :management_id, :primary_member_id)
    end
end
