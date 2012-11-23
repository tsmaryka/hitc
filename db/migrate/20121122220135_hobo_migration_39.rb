class HoboMigration39 < ActiveRecord::Migration
  def self.up
    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :researchers, :state, :string, :default => "not_approved"
    add_column :researchers, :key_timestamp, :datetime
    remove_column :researchers, :is_approved
    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    add_index :researchers, [:state]
  end

  def self.down
    change_column :community_members, :primary_language, :string

    change_column :consents, :date, :date, :default => '2012-11-17'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :researchers, :state
    remove_column :researchers, :key_timestamp
    add_column :researchers, :is_approved, :boolean
    change_column :researchers, :primary_language, :string

    remove_index :researchers, :name => :index_researchers_on_state rescue ActiveRecord::StatementInvalid
  end
end
