class HoboMigration32 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :consents, :date, :date, :default => :now

    change_column :study_enrollments, :state, :string, :default => "open", :limit => 255
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    change_column :consents, :date, :date, :default => '2012-11-12'

    change_column :study_enrollments, :state, :string, :default => "init"
  end
end
