class HoboMigration48 < ActiveRecord::Migration
  def self.up
    change_column :data_points, :data, :text, :limit => nil

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    change_column :consents, :date, :date, :default => :now

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255
  end

  def self.down
    change_column :data_points, :data, :string

    change_column :users, :user_type, :string, :default => "community"

    change_column :researchers, :primary_language, :string, :default => "english"

    change_column :consents, :date, :date, :default => '2012-11-24'

    change_column :community_members, :primary_language, :string, :default => "english"
  end
end
