class HoboMigration27 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :consents, :date, :date, :default => :now

    add_column :studies, :state, :string, :default => "no_consent"
    add_column :studies, :key_timestamp, :datetime

    add_index :studies, [:state]
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    change_column :consents, :date, :date, :default => '2012-11-05'

    remove_column :studies, :state
    remove_column :studies, :key_timestamp

    remove_index :studies, :name => :index_studies_on_state rescue ActiveRecord::StatementInvalid
  end
end
