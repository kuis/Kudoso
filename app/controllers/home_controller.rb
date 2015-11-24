class HomeController < ApplicationController

  def index

  end

  def founders_circle
    @contact = Contact.new
    @contact.fc_questionaire = FcQuestionaire.new
  end

  def limit

  end

  def protect

  end

  def teach

  end

  def reward

  end

  def contact_us

  end

end
