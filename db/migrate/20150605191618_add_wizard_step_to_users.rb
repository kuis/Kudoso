class AddWizardStepToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wizard_step, :integer, default: 1
  end
end
