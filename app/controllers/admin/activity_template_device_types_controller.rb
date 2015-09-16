class Admin::ActivityTemplateDeviceTypesController < AdminController

  load_and_authorize_resource

  # GET /activity_template_device_types
  # GET /activity_template_device_types.json
  def index
    @activity_template_device_types = ActivityTemplateDeviceType.all
  end

  # GET /activity_template_device_types/1
  # GET /activity_template_device_types/1.json
  def show
  end

  # GET /activity_template_device_types/new
  def new
    @activity_template_device_type = ActivityTemplateDeviceType.new
  end

  # GET /activity_template_device_types/1/edit
  def edit
  end

  # POST /activity_template_device_types
  # POST /activity_template_device_types.json
  def create
    @activity_template_device_type = ActivityTemplateDeviceType.new(activity_template_device_type_params)

    respond_to do |format|
      if @activity_template_device_type.save
        format.html { redirect_to admin_activity_template_device_types_url, notice: 'Activity template device type was successfully created.' }
        format.json { render :show, status: :created, location: @activity_template_device_type }
      else
        format.html { render :new }
        format.json { render json: @activity_template_device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_template_device_types/1
  # PATCH/PUT /activity_template_device_types/1.json
  def update
    respond_to do |format|
      if @activity_template_device_type.update(activity_template_device_type_params)
        format.html { redirect_to admin_activity_template_device_types_url, notice: 'Activity template device type was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_template_device_type }
      else
        format.html { render :edit }
        format.json { render json: @activity_template_device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_template_device_types/1
  # DELETE /activity_template_device_types/1.json
  def destroy
    @activity_template_device_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_activity_template_device_types_url, notice: 'Activity template device type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private


    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_template_device_type_params
      params.require(:activity_template_device_type).permit(:activity_template_id, :device_type_id, :type, :launch_url, :app_name, :app_id, :app_store_url)
    end
end
