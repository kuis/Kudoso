require 'rails_helper'

RSpec.describe TaskTemplate, :type => :model do
  it 'has a valid factory' do
    task_t = FactoryGirl.create(:task_template)
    expect(task_t.valid?).to be_truthy
  end

  it 'should return a formatted label' do
    task_t = FactoryGirl.create(:task_template)
    expect(task_t.label.is_a?(String)).to be_truthy
  end

  it 'should save a valid rule' do
    rule = IceCube::Rule.daily
    task_t = FactoryGirl.create(:task_template)
    task_t.rule = rule.to_yaml
    task_t.reload
    expect(task_t.schedule).to eq(rule.to_yaml)
    expect(task_t.errors.any?).to be_falsey

  end

  it 'should not save an invalid rule' do
    task_t = FactoryGirl.create(:task_template)
    rule = task_t.rule
    task_t.rule = 'wfwfwdfaa'
    task_t.reload
    expect(task_t.schedule).to eq(rule.to_yaml)
    expect(task_t.errors.any?).to be_truthy
  end

end
