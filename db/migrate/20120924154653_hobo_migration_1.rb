class HoboMigration1 < ActiveRecord::Migration
  def self.up
    add_column :users, :has_consented, :boolean, :default => false
  end

  def self.down
    remove_column :users, :has_consented
  end
end
