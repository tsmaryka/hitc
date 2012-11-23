class HoboMigration37 < ActiveRecord::Migration
  def self.up
    add_column :test_modules, :module_number, :integer
    remove_column :test_modules, :jimmyno

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    remove_column :test_modules, :module_number
    add_column :test_modules, :jimmyno, :integer

    change_column :consents, :date, :date, :default => '2012-11-17'

    change_column :users, :user_type, :string, :default => "community"
  end
end
