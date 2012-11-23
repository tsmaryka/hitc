class HoboMigration24 < ActiveRecord::Migration
  def self.up
    remove_column :users, :name
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :community_members, :name, :string

    change_column :consents, :date, :date, :default => :now

    add_column :researchers, :name, :string
  end

  def self.down
    add_column :users, :name, :string
    change_column :users, :user_type, :string, :default => "community"

    remove_column :community_members, :name

    change_column :consents, :date, :date, :default => '2012-10-28'

    remove_column :researchers, :name
  end
end
