class HoboMigration3 < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string, :default => :community
    add_column :users, :general_consent_accepted, :boolean, :default => false
  end

  def self.down
    remove_column :users, :type
    remove_column :users, :general_consent_accepted
  end
end
