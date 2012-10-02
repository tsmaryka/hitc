class HoboMigration5 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"
  end
end
