class ScreenTimeSchedulesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :screen_time_schedule, through: :member

  respond_to :html

  def index
    @screen_time_schedule = @member.screen_time_schedule
    respond_with(@screen_time_schedule)
  end

  def show
    respond_with(@screen_time_schedule)
  end

  def update
    if params[:screen_time_schedule].try(:[], :restrictions).present?
      restrictions = JSON.parse(params[:screen_time_schedule].try(:[], :restrictions))
      params[:screen_time_schedule][:restrictions] = nil
      if restrictions
        # process restrictions
        @screen_time_schedule.restrictions = restrictions
        if @screen_time_schedule.update_attribute(:restrictions, restrictions)
          respond_to do |format|
            format.html { redirect_to family_member_screen_times_path(@family, @member) }
            format.json { render json: {}, status: 200 }
          end
        else
          respond_to do |format|
            format.html { redirect_to family_member_screen_times_path(@family, @member), alert: @screen_time_schedule.errors.full_messages}
            format.json { render json: { error: @screen_time_schedule.errors.full_messages }, status: 500 }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to family_member_screen_times_path(@family, @member), alert: 'No updates found' }
          format.json { render json: { error: 'No updates found' }, status: 500 }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to family_member_screen_times_path(@family, @member), alert: 'No updates found'  }
        format.json { render json: { error: 'No updates found' }, status: 500 }
      end
    end

  end

  # def destroy
  #   @screen_time_schedule.destroy
  #   redirect_to family_member_screen_times_path(@family, @member)
  # end

  private

    def screen_time_schedule_params
      params.require(:screen_time_schedule).permit(:member_id, :family_id, :restrictions)
    end
end
