class HoboMigration21 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    add_column :researchers, :is_approved, :boolean

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-28'

    remove_column :researchers, :is_approved

    change_column :users, :user_type, :string, :default => "community"
  end
end
