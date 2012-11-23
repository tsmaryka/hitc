class HoboMigration26 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :study_invitations, :consent_accepted, :boolean
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-05'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :study_invitations, :consent_accepted
  end
end
