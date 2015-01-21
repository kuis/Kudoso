class AddFamactAndDefaultTimeToScreenTime < ActiveRecord::Migration
  def change
    add_column :screen_times, :family_activity_id, :integer
    add_column :screen_times, :default_time, :integer
  end
end
