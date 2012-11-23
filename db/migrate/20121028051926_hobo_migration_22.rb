class HoboMigration22 < ActiveRecord::Migration
  def self.up
    add_column :studies, :is_created, :boolean

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    remove_column :studies, :is_created

    change_column :consents, :date, :date, :default => '2012-10-28'

    change_column :users, :user_type, :string, :default => "community"
  end
end
