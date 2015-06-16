class AddDefaultScreenTimeToFamily < ActiveRecord::Migration
  def change
    add_column :families, :default_screen_time, :integer, default: (60*60*2)
    add_column :families, :default_filter, :string, default: 'monitor'
  end
end
