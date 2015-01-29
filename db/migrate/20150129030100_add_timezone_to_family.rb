class AddTimezoneToFamily < ActiveRecord::Migration
  def change
    add_column :families, :timezone, :string
  end
end
