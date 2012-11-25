class HoboMigration49 < ActiveRecord::Migration
  def self.up
    change_column :researchers, :primary_language, :string, :default => :english, :limit => 255

    remove_column :consent_texts, :study_id

    change_column :consents, :date, :date, :default => :now

    change_column :community_members, :primary_language, :string, :default => :english, :limit => 255

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    remove_index :consent_texts, :name => :index_consent_texts_on_study_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    change_column :researchers, :primary_language, :string, :default => "english"

    add_column :consent_texts, :study_id, :integer

    change_column :consents, :date, :date, :default => '2012-11-24'

    change_column :community_members, :primary_language, :string, :default => "english"

    change_column :users, :user_type, :string, :default => "community"

    add_index :consent_texts, [:study_id]
  end
end
