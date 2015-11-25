class HomeController < ApplicationController

  def index

  end

  def founders_circle
    @contact = Contact.new(contact_type_id: ContactType.find_or_create_by(name: 'Founders Circle Applicant').id )
    @contact.fc_questionaire = FcQuestionaire.new
    @contact.emails << Email.new
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
