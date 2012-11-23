class HoboMigration34 < ActiveRecord::Migration
  def self.up
    create_table :test_modules do |t|
      t.integer  :id
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    remove_column :study_enrollments, :key_timestamp
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-12'

    change_column :users, :user_type, :string, :default => "community"

    add_column :study_enrollments, :key_timestamp, :datetime

    drop_table :test_modules
  end
end
