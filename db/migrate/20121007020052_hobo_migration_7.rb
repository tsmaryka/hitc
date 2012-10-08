class HoboMigration7 < ActiveRecord::Migration
  def self.up
    create_table :community_members do |t|
      t.string   :street_address
      t.string   :city
      t.string   :province
      t.string   :postal_code
      t.string   :phone
      t.string   :primary_language
      t.date     :date_of_birth
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :community_members, [:user_id]

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-09-30'

    change_column :users, :user_type, :string, :default => "community"

    drop_table :community_members
  end
end
