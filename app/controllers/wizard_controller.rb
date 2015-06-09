class WizardController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def create
    if (1..4).include?(current_user.wizard_step)
      current_user.update_attribute(:wizard_step, current_user.wizard_step+1 )
    else
      current_user.update_attribute(:wizard_step, 0 )
    end
    respond_to do |format|
      format.js { render :index }
    end

  end

end
