class HoboMigration23 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    remove_column :studies, :is_created

    change_column :consents, :date, :date, :default => :now
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    add_column :studies, :is_created, :boolean

    change_column :consents, :date, :date, :default => '2012-10-28'
  end
end
