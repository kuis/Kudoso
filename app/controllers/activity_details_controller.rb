class ActivityDetailsController < ApplicationController
  before_action :set_activity_detail, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activity_details = ActivityDetail.all
    respond_with(@activity_details)
  end

  def show
    respond_with(@activity_detail)
  end

  def new
    @activity_detail = ActivityDetail.new
    respond_with(@activity_detail)
  end

  def edit
  end

  def create
    @activity_detail = ActivityDetail.new(activity_detail_params)
    @activity_detail.save
    respond_with(@activity_detail)
  end

  def update
    @activity_detail.update(activity_detail_params)
    respond_with(@activity_detail)
  end

  def destroy
    @activity_detail.destroy
    respond_with(@activity_detail)
  end

  private
    def set_activity_detail
      @activity_detail = ActivityDetail.find(params[:id])
    end

    def activity_detail_params
      params.require(:activity_detail).permit(:activity_id, :metadata)
    end
end
