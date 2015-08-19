class Admin::RoutersController < AdminController
  before_action :set_router, only: [:show, :edit, :update, :destroy]

  # GET /router_models
  # GET /router_models.json
  def index
    @routers = Router.all
  end

  # GET /router_models/1
  # GET /router_models/1.json
  def show
  end

  # GET /router_models/new
  def new
    @router = Router.new
  end

  # GET /router_models/1/edit
  def edit
  end

  # POST /router_models
  # POST /router_models.json
  def create
    @router = Router.new(router_params)

    respond_to do |format|
      if @router.save
        format.html { redirect_to admin_routers_url, notice: 'Router was successfully created.' }
        format.json { render :show, status: :created, location: @router }
      else
        format.html { render :new }
        format.json { render json: @router.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /router_models/1
  # PATCH/PUT /router_models/1.json
  def update
    respond_to do |format|
      if @router_model.update(router_model_params)
        format.html { redirect_to admin_routers_url, notice: 'Router was successfully updated.' }
        format.json { render :show, status: :ok, location: @router }
      else
        format.html { render :edit }
        format.json { render json: @router.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /router_models/1
  # DELETE /router_models/1.json
  def destroy
    @router.destroy
    respond_to do |format|
      format.html { redirect_to admin_routers_url, notice: 'Router was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_router
      @router = Router.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def router_params
      params.require(:router).permit(:router_model_id, :router_firmware_id, :family_id, :mac_address)
    end
end
