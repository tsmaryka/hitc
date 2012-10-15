class HoboMigration10 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :consents, :date, :date, :default => :now
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    change_column :consents, :date, :date, :default => '2012-10-07'
  end
end
