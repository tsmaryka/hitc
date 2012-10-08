class HoboMigration9 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-07'

    change_column :users, :user_type, :string, :default => "community"
  end
end
