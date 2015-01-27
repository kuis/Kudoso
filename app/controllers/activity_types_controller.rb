class ActivityTypesController < ApplicationController

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
    @activity_type = ActivityType.new(activity_type_params)
    @activity_type.save
    respond_with(@activity_type)
  end

  def update
    @activity_type.update(activity_type_params)
    respond_with(@activity_type)
  end

  def destroy
    @activity_type.destroy
    respond_with(@activity_type)
  end

  private

    def activity_type_params
      params.require(:activity_type).permit(:name).tap do |whitelisted|
        whitelisted[:metadata_fields] = params[:activity_type][:metadata_fields]
      end
    end
end
