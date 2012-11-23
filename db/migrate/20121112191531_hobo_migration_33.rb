class HoboMigration33 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :study_enrollments, :secret_key, :string, :unique => true
    remove_column :study_enrollments, :state

    change_column :consents, :date, :date, :default => :now

    remove_index :study_enrollments, :name => :index_study_enrollments_on_state rescue ActiveRecord::StatementInvalid
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    remove_column :study_enrollments, :secret_key
    add_column :study_enrollments, :state, :string, :default => "open"

    change_column :consents, :date, :date, :default => '2012-11-12'

    add_index :study_enrollments, [:state]
  end
end
