class HoboMigration13 < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string, :default => :community, :limit => 255

    change_column :consents, :date, :date, :default => :now

    add_column :consent_texts, :study_id, :integer

    add_index :consent_texts, [:study_id]
  end

  def self.down
    change_column :users, :user_type, :string, :default => "community"

    change_column :consents, :date, :date, :default => '2012-10-14'

    remove_column :consent_texts, :study_id

    remove_index :consent_texts, :name => :index_consent_texts_on_study_id rescue ActiveRecord::StatementInvalid
  end
end
