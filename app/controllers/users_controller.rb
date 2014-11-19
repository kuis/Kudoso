class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /households
  # GET /households.json
  def index
  end

  # GET /households/1
  # GET /households/1.json
  def show
  end

  # GET /households/new
  def new
  end

  # GET /households/1/edit
  def edit
  end

  # POST /households
  # POST /households.json
  def create

    respond_to do |format|
      if @household.save
        format.html { redirect_to @household, notice: 'Household was successfully created.' }
        format.json { render :show, status: :created, location: @household }
      else
        format.html { render :new }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /households/1
  # PATCH/PUT /households/1.json
  def update
    respond_to do |format|
      if @household.update(household_params)
        format.html { redirect_to @household, notice: 'Household was successfully updated.' }
        format.json { render :show, status: :ok, location: @household }
      else
        format.html { render :edit }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /households/1
  # DELETE /households/1.json
  def destroy
    @household.destroy
    respond_to do |format|
      format.html { redirect_to households_url, notice: 'Household was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_household
    @household = Household.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def household_params
    params.require(:household).permit(:name, :primary_contact_id)
  end
end
