class HoboMigration4 < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :string, :default => :community
    remove_column :users, :type
  end

  def self.down
    remove_column :users, :user_type
    add_column :users, :type, :string, :default => "community"
  end
end
