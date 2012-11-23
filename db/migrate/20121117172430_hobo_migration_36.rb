class HoboMigration36 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :test_modules, :jimmyno, :integer
    remove_column :test_modules, :module_id
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-17'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :test_modules, :jimmyno
    add_column :test_modules, :module_id, :integer
  end
end
