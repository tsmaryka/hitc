class HoboMigration40 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :test_modules, :module_identifier, :integer, :required => true
    remove_column :test_modules, :module_number

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-22'

    change_column :researchers, :primary_language, :string, :default => "english"

    change_column :users, :user_type, :string, :default => "community"

    remove_column :test_modules, :module_identifier
    add_column :test_modules, :module_number, :integer

    change_column :community_members, :primary_language, :string, :default => "english"
  end
end
