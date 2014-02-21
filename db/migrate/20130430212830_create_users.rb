class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :stormpath_url
      t.timestamps
    end
    add_index :users, :stormpath_url
  end
end
