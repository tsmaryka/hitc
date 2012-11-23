class HoboMigration35 < ActiveRecord::Migration
  def self.up
    add_column :test_modules, :module_id, :integer

    change_column :consents, :date, :date, :default => :now

    change_column :users, :user_type, :string, :default => :community, :limit => 255

    add_column :studies, :test_module_id, :integer

    add_index :studies, [:test_module_id]
  end

  def self.down
    remove_column :test_modules, :module_id

    change_column :consents, :date, :date, :default => '2012-11-17'

    change_column :users, :user_type, :string, :default => "community"

    remove_column :studies, :test_module_id

    remove_index :studies, :name => :index_studies_on_test_module_id rescue ActiveRecord::StatementInvalid
  end
end
