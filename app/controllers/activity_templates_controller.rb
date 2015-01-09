class ActivityTemplatesController < ApplicationController
  before_action :set_activity_template, only: [:show, :edit, :update, :destroy]

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
    respond_with(@activity_template)
  end

  private
    def set_activity_template
      @activity_template = ActivityTemplate.find(params[:id])
    end

    def activity_template_params
      params.require(:activity_template).permit(:name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted)
    end
end
