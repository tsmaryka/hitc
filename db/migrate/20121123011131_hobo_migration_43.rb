class HoboMigration43 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255

    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    add_column :study_invitations, :consent_accepted, :boolean, :default => false
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-23'

    change_column :users, :user_type, :string, :default => "community"

    change_column :community_members, :primary_language, :string, :default => "english"

    change_column :researchers, :primary_language, :string, :default => "english"

    remove_column :study_invitations, :consent_accepted
  end
end
