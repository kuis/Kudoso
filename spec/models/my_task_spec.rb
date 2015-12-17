require 'rails_helper'

RSpec.describe MyTask, :type => :model do
  it 'has a valid factory' do
    my_task = FactoryGirl.create(:my_task)
    expect(my_task.valid?).to be_truthy
  end

  it 'should add and remove kudos to member with saving/destroying' do
    @member = FactoryGirl.create(:member)
    template = FactoryGirl.create(:task_template, kudos: 10)
    @member.family.assign_template(template, [@member.id])


    #make schedule start in past
    @member.task_schedules.find_each do |ts|
      ts.start_date =  Date.yesterday
      ts.save!(validate: false)
    end

    before_kudos = @member.kudos
    Family.memorialize_tasks( Date.yesterday)

    @member.my_tasks.last.update_attribute(:complete, true)
    expect(@member.kudos).to eq(before_kudos + 10)
    @member.my_tasks.last.update_attribute(:complete, false)
    expect(@member.kudos).to eq(before_kudos)
  end

  it 'should not allow saving someone elses task schedule' do
    @member = FactoryGirl.create(:member)
    ts = FactoryGirl.create(:task_schedule)
    expect(ts.member).not_to eq(@member)
    my_task = @member.my_tasks.create(task_schedule_id: ts.id, due_date: Date.today)
    expect(my_task.valid?).to be_falsey
  end


end
