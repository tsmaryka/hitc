class HoboMigration25 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    add_column :study_invitations, :state, :string, :default => "invited"
    add_column :study_invitations, :key_timestamp, :datetime

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_index :study_invitations, [:state]
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-04'

    remove_column :study_invitations, :state
    remove_column :study_invitations, :key_timestamp

    change_column :users, :user_type, :string, :default => "community"

    remove_index :study_invitations, :name => :index_study_invitations_on_state rescue ActiveRecord::StatementInvalid
  end
end
