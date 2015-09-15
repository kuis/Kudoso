class Admin::PlugsController < AdminController
  before_action :set_plug, only: [:show, :edit, :update, :destroy]

  # GET /plugs
  # GET /plugs.json
  def index
    @plugs = Plug.all
  end

  # GET /plugs/1
  # GET /plugs/1.json
  def show
  end

  # GET /plugs/new
  def new
    @plug = Plug.new
  end

  # GET /plugs/1/edit
  def edit
  end

  # POST /plugs
  # POST /plugs.json
  def create
    @plug = Plug.new(plug_params)

    respond_to do |format|
      if @plug.save
        format.html { redirect_to [:admin, @plug], notice: 'Plug was successfully created.' }
        format.json { render :show, status: :created, location: @plug }
      else
        format.html { render :new }
        format.json { render json: @plug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plugs/1
  # PATCH/PUT /plugs/1.json
  def update
    respond_to do |format|
      if @plug.update(plug_params)
        format.html { redirect_to [:admin, @plug], notice: 'Plug was successfully updated.' }
        format.json { render :show, status: :ok, location: @plug }
      else
        format.html { render :edit }
        format.json { render json: @plug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plugs/1
  # DELETE /plugs/1.json
  def destroy
    @plug.destroy
    respond_to do |format|
      format.html { redirect_to admin_plugs_url, notice: 'Plug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plug
      @plug = Plug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plug_params
      params.require(:plug).permit(:mac_address, :serial, :secure_key, :last_seen, :registered, :last_known_ip, :device_id)
    end
end
