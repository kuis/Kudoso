class CreateRouterModels < ActiveRecord::Migration
  def self.up
    create_table :router_models do |t|
      t.string :name
      t.string :num

      t.timestamps null: false
    end
    model = RouterModel.create({name: 'Kudoso Full River 802.11ac Router', num: 'KFR11AC-128R-16F'})
  end

  def self.down
    drop_table :router_models
  end
end
