class HoboMigration15 < ActiveRecord::Migration
  def self.up
    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :studies, :body, :text
    remove_column :studies, :description
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-14'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :studies, :body
    add_column :studies, :description, :text
  end
end
