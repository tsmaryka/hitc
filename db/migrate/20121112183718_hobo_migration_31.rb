class HoboMigration31 < ActiveRecord::Migration
  def self.up
    change_column :study_enrollments, :state, :string, :default => "init", :limit => 255

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :study_enrollments, :state, :string, :default => "open"

    change_column :consents, :date, :date, :default => '2012-11-12'

    change_column :users, :user_type, :string, :default => "community"
  end
end
