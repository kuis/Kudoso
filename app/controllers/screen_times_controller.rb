class ScreenTimesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :screen_time, through: :member

  respond_to :html

  def index
    @screen_times = @member.screen_times.all
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
    if  params[:clear_activities].present?
      @screen_times = @member.screen_times.all
      @screen_times.each do |screen_time|
         screen_time.restrictions[:activities] = {}
         screen_time.save
      end
      redirect_to(family_member_screen_times_path(@family, @member), notice: 'Reset screen times for activities!')
    elsif params[:clear_devices].present?
      @screen_times = @member.screen_times.all
      @screen_times.each do |screen_time|
        screen_time.restrictions[:devices] = {}
        screen_time.save
      end
      redirect_to(family_member_screen_times_path(@family, @member), notice: 'Reset screen times for devices!')
    else

      updated_params = screen_time_params.merge({ member_id: @member.id})
      updated_params[:default_time] = updated_params[:max_time] if updated_params[:default_time].blank?
      updated_params[:max_time] = updated_params[:default_time] if updated_params[:max_time].blank?
      @screen_time = ScreenTime.new(updated_params)
      if @screen_time.save
        redirect_to(family_member_screen_times_path(@family, @member), notice: 'Updated screen time!')
      else
        redirect_to(family_member_screen_times_path(@family, @member), alert: @screen_time.errors.full_messages[0])
      end
    end

  end

  def update
    if params[:screen_time].try(:[], :restrict).present?
      restrictions = JSON.parse(params[:screen_time].try(:[], :restrict))
      params[:screen_time][:restrict] = nil
      if restrictions
        if restrictions['activities'].present?
          restrictions['activities'].each do |fam_act_id, times|
            fam_act_id = fam_act_id.to_i
            @screen_time.restrictions[:activities][fam_act_id] ||= {}
            if times['default_time']
              @screen_time.restrictions[:activities][fam_act_id][:default_time] = times['default_time'].to_i
              @screen_time.restrictions[:activities][fam_act_id][:max_time] ||= @screen_time.max_time
            end
            if times['max_time']
              @screen_time.restrictions[:activities][fam_act_id][:max_time] = times['max_time'].to_i
              @screen_time.restrictions[:activities][fam_act_id][:default_time] ||= (@screen_time.default_time <  times['max_time'].to_i ? @screen_time.default_time : times['max_time'].to_i)
            end

          end
          @screen_time.save
          redirect_to(family_member_screen_times_path(@family, @member), notice: 'Updated screen times for activities!')
        elsif restrictions['devices'].present?
          restrictions['devices'].each do |device_id, times|
            device_id = device_id.to_i
            @screen_time.restrictions[:devices][device_id] ||= {}
            if times['default_time']
              @screen_time.restrictions[:devices][device_id][:default_time] = times['default_time'].to_i
              @screen_time.restrictions[:devices][device_id][:max_time] ||= @screen_time.max_time
            end
            if times['max_time']
              @screen_time.restrictions[:devices][device_id][:max_time] = times['max_time'].to_i
              @screen_time.restrictions[:devices][device_id][:default_time] ||= (@screen_time.default_time <  times['max_time'].to_i ? @screen_time.default_time : times['max_time'].to_i)
            end
          end
          @screen_time.save
          redirect_to(family_member_screen_times_path(@family, @member), notice: 'Updated screen times for devices!')
        end
      end
    else
      if @screen_time.update(screen_time_params.merge({ member_id: @member.id}))
        redirect_to(family_member_screen_times_path(@family, @member), notice: 'Updated screen time!')
      else
        redirect_to(family_member_screen_times_path(@family, @member), alert: @screen_time.errors.full_messages[0] )
      end
    end

  end

  def destroy
    @screen_time.destroy
    redirect_to family_member_screen_times_path(@family, @member)
  end

  private

    def screen_time_params
      params.require(:screen_time).permit(:member_id, :dow, :max_time, :default_time, :restrict)
    end
end
