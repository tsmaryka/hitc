class HoboMigration18 < ActiveRecord::Migration
  def self.up
    create_table :reserachers do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :reserachers, [:user_id]

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-14'

    change_column :users, :user_type, :string, :default => "community"

    drop_table :reserachers
  end
end
