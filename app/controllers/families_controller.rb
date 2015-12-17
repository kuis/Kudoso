class FamiliesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /families
  # GET /families.json
  def index
    authorize! :index, Family
  end

  # GET /families/1
  # GET /families/1.json
  def show
    if current_user.wizard_step != 0
      redirect_to '/wizard', alert: 'Please complete the setup wizard to continue.'
      return
    end
    @todo_templates = TodoTemplate.all
  end

  # GET /families/new
  def new
  end

  # GET /families/1/edit
  def edit
  end

  # POST /families
  # POST /families.json
  def create

    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: 'Family was successfully created.' }
        format.json { render :show, status: :created, location: @family }
      else
        format.html { render :new }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: 'Family was successfully updated.' }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    @family.destroy
    respond_to do |format|
      format.html { redirect_to families_url, notice: 'Family was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :primary_contact_id)
    end
end
