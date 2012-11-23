class HoboMigration30 < ActiveRecord::Migration
  def self.up
    add_column :study_enrollments, :state, :string, :default => "open"
    add_column :study_enrollments, :key_timestamp, :datetime

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :consents, :date, :date, :default => :now

    add_index :study_enrollments, [:state]
  end

  def self.down
    remove_column :study_enrollments, :state
    remove_column :study_enrollments, :key_timestamp

    change_column :users, :user_type, :string, :default => "community"

    change_column :consents, :date, :date, :default => '2012-11-05'

    remove_index :study_enrollments, :name => :index_study_enrollments_on_state rescue ActiveRecord::StatementInvalid
  end
end
