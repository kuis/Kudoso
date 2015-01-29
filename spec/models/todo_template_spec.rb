require 'rails_helper'

RSpec.describe TodoTemplate, :type => :model do
  it 'has a valid factory' do
    todo_t = FactoryGirl.create(:todo_template)
    expect(todo_t.valid?).to be_truthy
  end

  it 'should return a formatted label' do
    todo_t = FactoryGirl.create(:todo_template)
    expect(todo_t.label.is_a?(String)).to be_truthy
  end

  it 'should save a valid rule' do
    rule = IceCube::Rule.daily
    todo_t = FactoryGirl.create(:todo_template)
    todo_t.rule = rule.to_yaml
    todo_t.reload
    expect(todo_t.schedule).to eq(rule.to_yaml)
    expect(todo_t.errors.any?).to be_falsey

  end

  it 'should not save an invalid rule' do
    todo_t = FactoryGirl.create(:todo_template)
    rule = todo_t.rule
    todo_t.rule = 'wdfwdfwfd'
    todo_t.reload
    expect(todo_t.schedule).to eq(rule.to_yaml)
    expect(todo_t.errors.any?).to be_truthy
  end

end
