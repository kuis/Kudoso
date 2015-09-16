class Admin::ActivityTemplatesController < AdminController
  load_and_authorize_resource

  respond_to :html

  def index
    @activity_templates = ActivityTemplate.all
    respond_with(@activity_templates)
  end

  def show
    respond_with(@activity_template)
  end

  def new
    @activity_template = ActivityTemplate.new
    respond_with(@activity_template)
  end

  def edit
  end

  def create
    @activity_template = ActivityTemplate.new(activity_template_params)

    respond_to do |format|
      if @activity_template.save
        format.html { redirect_to admin_activity_templates_url, notice: 'Activity Template was successfully created.' }
        format.json { render :show, status: :created, location: @activity_template }
      else
        format.html { render :new }
        format.json { render json: @activity_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @activity_template.update(activity_template_params)
        format.html { redirect_to admin_activity_templates_url, notice: 'Activity Template was successfully created.' }
        format.json { render :show, status: :created, location: @activity_template }
      else
        format.html { render :new }
        format.json { render json: @activity_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity_template.destroy
    respond_to do |format|
      format.html { redirect_to admin_activity_templates_url, notice: 'Activity Template was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private


    def activity_template_params
      params.require(:activity_template).permit(:name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted, :activity_type_id)
    end
end
