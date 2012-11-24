class HoboMigration47 < ActiveRecord::Migration
  def self.up
    create_table :data_points do |t|
      t.string   :data
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :study_enrollment_id
    end
    add_index :data_points, [:study_enrollment_id]

    change_column :consents, :date, :date, :default => :now

    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255

    add_column :study_enrollments, :state, :string, :default => "enrolled"
    add_column :study_enrollments, :key_timestamp, :datetime

    add_index :study_enrollments, [:state]
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-23'

    change_column :researchers, :primary_language, :string, :default => "english"

    change_column :users, :user_type, :string, :default => "community"

    change_column :community_members, :primary_language, :string, :default => "english"

    remove_column :study_enrollments, :state
    remove_column :study_enrollments, :key_timestamp

    drop_table :data_points

    remove_index :study_enrollments, :name => :index_study_enrollments_on_state rescue ActiveRecord::StatementInvalid
  end
end
