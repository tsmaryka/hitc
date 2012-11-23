class HoboMigration29 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    add_column :studies, :consent_text_id, :integer

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_index :studies, [:consent_text_id]
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-11-05'

    remove_column :studies, :consent_text_id

    change_column :users, :user_type, :string, :default => "community"

    remove_index :studies, :name => :index_studies_on_consent_text_id rescue ActiveRecord::StatementInvalid
  end
end
