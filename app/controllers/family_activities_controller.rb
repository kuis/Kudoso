class FamilyActivitiesController < ApplicationController
  before_action :set_family_activity, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @family_activities = FamilyActivity.all
    respond_with(@family_activities)
  end

  def show
    respond_with(@family_activity)
  end

  def new
    @family_activity = FamilyActivity.new
    respond_with(@family_activity)
  end

  def edit
  end

  def create
    @family_activity = FamilyActivity.new(family_activity_params)
    @family_activity.save
    respond_with(@family_activity)
  end

  def update
    @family_activity.update(family_activity_params)
    respond_with(@family_activity)
  end

  def destroy
    @family_activity.destroy
    respond_with(@family_activity)
  end

  private
    def set_family_activity
      @family_activity = FamilyActivity.find(params[:id])
    end

    def family_activity_params
      params.require(:family_activity).permit(:family_id, :activity_template_id, :name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted)
    end
end
