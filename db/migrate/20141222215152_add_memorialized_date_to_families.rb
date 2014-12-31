class AddMemorializedDateToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :memorialized_date, :date
  end
end
