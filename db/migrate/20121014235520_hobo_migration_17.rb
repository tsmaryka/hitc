class HoboMigration17 < ActiveRecord::Migration
  def self.up
    create_table :researchers do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :researchers, [:user_id]

    create_table :managers do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :managers, [:user_id]

    add_column :study_enrollments, :community_member_id, :integer
    remove_column :study_enrollments, :user_id

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :study_ownerships, :researcher_id, :integer
    remove_column :study_ownerships, :user_id

    add_column :study_invitations, :community_member_id, :integer
    remove_column :study_invitations, :user_id

    remove_index :study_enrollments, :name => :index_study_enrollments_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :study_enrollments, [:community_member_id]

    remove_index :study_ownerships, :name => :index_study_ownerships_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :study_ownerships, [:researcher_id]

    remove_index :study_invitations, :name => :index_study_invitations_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :study_invitations, [:community_member_id]
  end

  def self.down
    remove_column :study_enrollments, :community_member_id
    add_column :study_enrollments, :user_id, :integer

    change_column :consents, :date, :date, :default => '2012-10-14'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :study_ownerships, :researcher_id
    add_column :study_ownerships, :user_id, :integer

    remove_column :study_invitations, :community_member_id
    add_column :study_invitations, :user_id, :integer

    drop_table :researchers
    drop_table :managers

    remove_index :study_enrollments, :name => :index_study_enrollments_on_community_member_id rescue ActiveRecord::StatementInvalid
    add_index :study_enrollments, [:user_id]

    remove_index :study_ownerships, :name => :index_study_ownerships_on_researcher_id rescue ActiveRecord::StatementInvalid
    add_index :study_ownerships, [:user_id]

    remove_index :study_invitations, :name => :index_study_invitations_on_community_member_id rescue ActiveRecord::StatementInvalid
    add_index :study_invitations, [:user_id]
  end
end
