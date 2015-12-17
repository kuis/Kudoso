class ActivitiesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :activity, through: :member

  respond_to :html

  def index
    @activities = @member.activities.all
    respond_with(@activities)
  end

  def show
    respond_with(@activity)
  end

  def new
    if params[:activity_template_id]
      activity_template = ActivityTemplate.find(params[:activity_template_id])
      if !activity_template.restricted? || (activity_template.restricted? && @member.todos_complete?)
        @activity = @member.new_activity(activity_template, nil)
        if params[:start]
          @activity.start!
          flash[:notice] = "You have started #{activity_template.name}, enjoy!"
        end
        redirect_to [@family, @member]
      else
        flash[:alert] = 'Sorry, you must complete your required ToDos before starting a restricted activity.'
        redirect_to [@family, @member]
      end
    else
      @activity = @member.activities.build
      respond_with(@activity)
    end
  end

  def edit
  end

  def create
    params[:activity][:member_id] = @member.id
    @activity = @member.activities.build(activity_params)
    @activity.save
    respond_with(@activity)
  end

  def update
    if params[:stop]
      @activity.stop!
      flash[:notice] = "You have stoped #{@activity.activity_template.name}."
      redirect_to [@family, @member]
    else
      params[:activity][:member_id] = @member.id
      @activity.update(activity_params)
      respond_with(@activity)
    end
  end

  def destroy
    @activity.destroy
    respond_with(@activity)
  end

  private
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:member_id, :created_by, :activity_template_id, :start_time, :end_time, :device_id, :content_id, :allowed_time, :cost, :reward)
      params.permit(:activity_template_id, :start)
    end
end
