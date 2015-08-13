class RouterModelsController < ApplicationController
  before_action :set_router_model, only: [:show, :edit, :update, :destroy]

  # GET /router_models
  # GET /router_models.json
  def index
    @router_models = RouterModel.all
  end

  # GET /router_models/1
  # GET /router_models/1.json
  def show
  end

  # GET /router_models/new
  def new
    @router_model = RouterModel.new
  end

  # GET /router_models/1/edit
  def edit
  end

  # POST /router_models
  # POST /router_models.json
  def create
    @router_model = RouterModel.new(router_model_params)

    respond_to do |format|
      if @router_model.save
        format.html { redirect_to @router_model, notice: 'Router model was successfully created.' }
        format.json { render :show, status: :created, location: @router_model }
      else
        format.html { render :new }
        format.json { render json: @router_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /router_models/1
  # PATCH/PUT /router_models/1.json
  def update
    respond_to do |format|
      if @router_model.update(router_model_params)
        format.html { redirect_to @router_model, notice: 'Router model was successfully updated.' }
        format.json { render :show, status: :ok, location: @router_model }
      else
        format.html { render :edit }
        format.json { render json: @router_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /router_models/1
  # DELETE /router_models/1.json
  def destroy
    @router_model.destroy
    respond_to do |format|
      format.html { redirect_to router_models_url, notice: 'Router model was successfully destroyed.' }
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
