class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.datetime :expires_at
      t.integer :member_id
      t.integer :user_id

      t.timestamps
    end
  end
end
