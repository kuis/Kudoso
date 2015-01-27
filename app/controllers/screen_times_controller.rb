class ScreenTimesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :screen_time, through: :member

  respond_to :html

  def index
    @screen_times = ScreenTime.all
    respond_with(@screen_times)
  end

  def show
    respond_with(@screen_time)
  end

  def new
    @screen_time = ScreenTime.new
    respond_with(@screen_time)
  end

  def edit
  end

  def create
    @screen_time = ScreenTime.new(screen_time_params)
    @screen_time.save
    respond_with(@screen_time)
  end

  def update
    @screen_time.update(screen_time_params)
    respond_with(@screen_time)
  end

  def destroy
    @screen_time.destroy
    respond_with(@screen_time)
  end

  private

    def screen_time_params
      params.require(:screen_time).permit(:member_id, :dow, :max_time, :default_time, :restrictions)
    end
end
