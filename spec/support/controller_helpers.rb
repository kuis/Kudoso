module ControllerHelpers
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end

  def sign_in_member(member = double('member'))
    if member.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :member})
      allow(controller).to receive(:current_member).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(member)
      allow(controller).to receive(:current_member).and_return(member)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end