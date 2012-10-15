class HoboMigration12 < ActiveRecord::Migration
  def self.up
    create_table :study_ownerships do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :study_id
    end
    add_index :study_ownerships, [:user_id]
    add_index :study_ownerships, [:study_id]

    create_table :studies do |t|
      t.string   :title
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :study_invitations do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :study_id
    end
    add_index :study_invitations, [:user_id]
    add_index :study_invitations, [:study_id]

    create_table :study_enrollments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :study_id
    end
    add_index :study_enrollments, [:user_id]
    add_index :study_enrollments, [:study_id]

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-12'

    change_column :users, :user_type, :string, :default => "community"

    drop_table :study_ownerships
    drop_table :studies
    drop_table :study_invitations
    drop_table :study_enrollments
  end
end
