class Admin::RouterFirmwaresController < AdminController
  before_action :set_router_firmware, only: [:show, :edit, :update, :destroy]

  # GET /admin/router_firmwares
  # GET /admin/router_firmwares.json
  def index
    @router_firmwares = RouterFirmware.all
  end

  # GET /admin/router_firmwares/1
  # GET /admin/router_firmwares/1.json
  def show
  end

  # GET /admin/router_firmwares/new
  def new
    @router_firmware = RouterFirmware.new
  end

  # GET /admin/router_firmwares/1/edit
  def edit
  end

  # POST /admin/router_firmwares
  # POST /admin/router_firmwares.json
  def create
    @router_firmware = RouterFirmware.new(router_firmware_params)

    respond_to do |format|
      if @router_firmware.save
        format.html { redirect_to admin_router_firmwares_url, notice: 'Router firmware was successfully created.' }
        format.json { render :show, status: :created, location: @router_firmware }
      else
        format.html { render :new }
        format.json { render json: @router_firmware.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/router_firmwares/1
  # PATCH/PUT /admin/router_firmwares/1.json
  def update
    respond_to do |format|
      if @router_firmware.update(router_firmware_params)
        format.html { redirect_to admin_router_firmwares_url, notice: 'Router firmware was successfully updated.' }
        format.json { render :show, status: :ok, location: @router_firmware }
      else
        format.html { render :edit }
        format.json { render json: @router_firmware.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/router_firmwares/1
  # DELETE /admin/router_firmwares/1.json
  def destroy
    @router_firmware.destroy
    respond_to do |format|
      format.html { redirect_to admin_router_firmwares_url, notice: 'Router firmware was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_router_firmware
      @router_firmware = RouterFirmware.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def router_firmware_params
      params.require(:router_firmware).permit(:router_model_id, :version, :checksum, :notes, :firmware)
    end
end
