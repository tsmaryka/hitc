class HoboMigration41 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :test_modules, :module_identifier, :string, :limit => 255

    change_column :consents, :date, :date, :default => :now

    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    change_column :test_modules, :module_identifier, :integer

    change_column :consents, :date, :date, :default => '2012-11-23'

    change_column :researchers, :primary_language, :string, :default => "english"

    change_column :community_members, :primary_language, :string, :default => "english"
  end
end
