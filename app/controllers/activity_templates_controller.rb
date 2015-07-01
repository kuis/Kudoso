class ActivityTemplatesController < ApplicationController
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
    @activity_template.save
    respond_with(@activity_template)
  end

  def update
    @activity_template.update(activity_template_params)
    respond_with(@activity_template)
  end

  def destroy
    @activity_template.destroy
    # respond_with(@activity_template)
    redirect_to activity_templates_path
  end

  private


    def activity_template_params
      params.require(:activity_template).permit(:name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted, :activity_type_id)
    end
end
