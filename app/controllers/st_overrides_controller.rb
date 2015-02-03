class StOverridesController < ApplicationController
  load_and_authorize_resource :family
  load_and_authorize_resource :member, through: :family
  load_and_authorize_resource :st_override, through: :member

  respond_to :html

  def index
    @st_overrides = @member.st_overrides.all
    respond_with(@st_overrides)
  end

  def show
    respond_with(@st_override)
  end

  def new
    @st_override = @member.st_overrides.new
    respond_with(@st_override)
  end

  def edit
    redirect_to [@family, @member], alert: 'Sorry, Screen Time Overrides cannot be edited.'
  end

  def create
    @st_override = StOverride.new(st_override_params.merge(member_id: @member.id, created_by_id: current_member.try(:id)))
    if @st_override.save
      redirect_to [@family, @member]
    else
      respond_with(@st_override)
    end

  end

  def update
    redirect_to [@family, @member], alert: 'Sorry, Screen Time Overrides cannot be updated.'
  end

  def destroy
    @st_override.destroy
    redirect_to [@family, @member]
  end

  private


    def st_override_params
      params.require(:st_override).permit(:member_id, :created_by_id, :time, :date, :comment)
    end
end
