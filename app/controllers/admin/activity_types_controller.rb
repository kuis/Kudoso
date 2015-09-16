class Admin::ActivityTypesController < AdminController

  load_and_authorize_resource
  respond_to :html

  def index
    @activity_types = ActivityType.all
    respond_with(@activity_types)
  end

  def show
    respond_with(@activity_type)
  end

  def new
    @activity_type = ActivityType.new
    respond_with(@activity_type)
  end

  def edit
  end

  def create
    @activity_type = ActivityTemplate.new(activity_template_params)

    respond_to do |format|
      if @activity_type.save
        format.html { redirect_to admin_activity_templates_url, notice: 'Activity Type was successfully created.' }
        format.json { render :show, status: :created, location: @activity_type }
      else
        format.html { render :new }
        format.json { render json: @activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @activity_type.update(activity_template_params)
        format.html { redirect_to admin_activity_templates_url, notice: 'Activity Type was successfully created.' }
        format.json { render :show, status: :created, location: @activity_type }
      else
        format.html { render :new }
        format.json { render json: @activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_activity_types_url, notice: 'Activity Type was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private

    def activity_type_params
      params.require(:activity_type).permit(:name).tap do |whitelisted|
        whitelisted[:metadata_fields] = params[:activity_type].try(:[], :metadata_fields).is_a?(Hash) ? params[:activity_type][:metadata_fields] : {}
      end
    end
end
