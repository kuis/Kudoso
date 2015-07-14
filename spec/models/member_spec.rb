require 'rails_helper'

RSpec.describe Member, :type => :model do
  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it 'has a valid factory' do
    expect(@member.valid?).to be_truthy
    expect(@member.full_name).to eq("#{@member.first_name} #{@member.last_name}")
  end

  it 'secures the members password' do
    pwd = 'thepassword'
    new_member = Member.create(username: 'thetest', password: pwd, password_confirmation: pwd, birth_date: 10.years.ago, family_id: @member.family_id)
    expect(new_member.valid_password?(pwd)).to be_falsey
    expect(new_member.valid_password?(Digest::MD5.hexdigest(pwd + @member.family.secure_key))).to be_truthy
  end

  it 'should not allow duplicate usernames within a fmaily' do
    member_2 = Member.new( username: @member.username, family_id: @member.family_id)
    expect(member_2.valid?).to be_falsey
    expect(member_2.errors[:username].any?).to be_truthy
  end

  it 'should return available screen time' do
    expect(@member.available_screen_time).to eq(@member.family.default_screen_time) # 24 hours in seconds

    @member.set_screen_time!(Date.today.wday, 3600, 4800)
    expect(@member.available_screen_time).to eq(3600)

    device = FactoryGirl.create(:device, family_id: @member.family.id )
    @member.set_screen_time!(Date.today.wday, 1800, 3600, device.id)
    expect(@member.available_screen_time).to eq(3600)
    expect(@member.available_screen_time(Date.today, device.id)).to eq(1800)
  end

  it 'should record activities as screen time' do
    device = FactoryGirl.create(:device, family_id: @member.family.id )
    start_time = @member.available_screen_time(Date.today, device.id)
    activity_template = FactoryGirl.create(:activity_template)
    act = @member.new_activity(activity_template, device)
    act.start!
    sleep(3)
    act.stop!
    end_time = @member.available_screen_time(Date.today, device.id)
    used_time = @member.used_screen_time(Date.today, device.id)
    expect(used_time).to eq(act.duration)
    expect(used_time).to eq(start_time-end_time)
  end

  context 'with a month of todos' do

    before(:each) do
      @member = FactoryGirl.create(:member)
      template = FactoryGirl.create(:todo_template)
      template.rule = IceCube::Rule.daily.to_yaml
      @member.family.assign_template(template, [@member.id])


      #make schedule start in past
      @member.todo_schedules.find_each do |ts|
        ts.start_date = 31.days.ago.to_date
        ts.save!(validate: false)
      end
      day_ctr = 0
      ( (Date.today - 1.month) .. (Date.yesterday) ).each { |d| Family.memorialize_todos(d); day_ctr += 1 }
      expect(@member.my_todos.count).to eq(day_ctr)
    end

    it 'should return a months worth of my_todos when details are called' do
      @member.reload
      expect(@member.details.count).to be >= 28 #depends on the month the test is run
    end

    it 'should return todos for today or a date range' do
      @member.reload
      todos = @member.todos #for today
      expect(todos.count).to eq(1)

      todos = @member.todos(Date.today, Date.today + 3.days) #for today
      expect(todos.count).to eq(4)
    end

  end


end
