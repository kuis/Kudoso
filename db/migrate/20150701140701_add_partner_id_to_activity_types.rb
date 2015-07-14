class AddPartnerIdToActivityTypes < ActiveRecord::Migration
  def change
    add_column :activity_types, :partner_id, :integer
  end
end
