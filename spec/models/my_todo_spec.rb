require 'rails_helper'

RSpec.describe MyTodo, :type => :model do
  it 'has a valid factory' do
    my_todo = FactoryGirl.create(:my_todo)
    expect(my_todo.valid?).to be_truthy
  end

  it 'should add and remove kudos to member with saving/destroying' do
    @member = FactoryGirl.create(:member)
    template = FactoryGirl.create(:todo_template, kudos: 10)
    @member.family.assign_template(template, [@member.id])


    #make schedule start in past
    @member.todo_schedules.find_each do |ts|
      ts.start_date =  Date.yesterday
      ts.save!(validate: false)
    end

    before_kudos = @member.kudos
    Family.memorialize_todos( Date.yesterday)

    @member.my_todos.last.update_attribute(:complete, true)
    expect(@member.kudos).to eq(before_kudos + 10)
    @member.my_todos.last.update_attribute(:complete, false)
    expect(@member.kudos).to eq(before_kudos)
  end

  it 'should not allow saving someone elses todo schedule' do
    @member = FactoryGirl.create(:member)
    ts = FactoryGirl.create(:todo_schedule)
    expect(ts.member).not_to eq(@member)
    my_todo = @member.my_todos.create(todo_schedule_id: ts.id, due_date: Date.today)
    expect(my_todo.valid?).to be_falsey
  end


end
