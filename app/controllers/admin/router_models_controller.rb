class Admin::RouterModelsController < AdminController
  before_action :set_router_model, only: [:show, :edit, :update, :destroy]

  # GET /admin/router_firmwares
  # GET /admin/router_firmwares.json
  def index
    @router_models = RouterModel.all
  end

  # GET /admin/router_firmwares/1
  # GET /admin/router_firmwares/1.json
  def show
  end

  # GET /admin/router_firmwares/new
  def new
    @router_model = RouterModel.new
  end

  # GET /admin/router_firmwares/1/edit
  def edit
  end

  # POST /admin/router_firmwares
  # POST /admin/router_firmwares.json
  def create
    @router_model = RouterModel.new(router_model_params)

    respond_to do |format|
      if @router_model.save
        format.html { redirect_to admin_router_models_url, notice: 'Router model was successfully created.' }
        format.json { render :show, status: :created, location: @router_model }
      else
        format.html { render :new }
        format.json { render json: @router_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/router_firmwares/1
  # PATCH/PUT /admin/router_firmwares/1.json
  def update
    respond_to do |format|
      if @router_model.update(router_model_params)
        format.html { redirect_to admin_router_models_url, notice: 'Router model was successfully updated.' }
        format.json { render :show, status: :ok, location: @router_model }
      else
        format.html { render :edit }
        format.json { render json: @router_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/router_firmwares/1
  # DELETE /admin/router_firmwares/1.json
  def destroy
    @router_model.destroy
    respond_to do |format|
      format.html { redirect_to admin_router_models_url, notice: 'Router model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_router_model
      @router_model = RouterModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def router_model_params
      params.require(:router_model).permit(:name, :num)
    end
end
