class HoboMigration20 < ActiveRecord::Migration
  def self.up
    drop_table :reserachers

    change_column :consents, :date, :date, :default => :now

    add_column :researchers, :street_address, :string
    add_column :researchers, :city, :string
    add_column :researchers, :province, :string
    add_column :researchers, :postal_code, :string
    add_column :researchers, :phone, :string
    add_column :researchers, :primary_language, :string
    add_column :researchers, :date_of_birth, :date

    change_column :users, :user_type, :string, :default => :community, :limit => 255
  end

  def self.down
    change_column :consents, :date, :date, :default => '2012-10-22'

    remove_column :researchers, :street_address
    remove_column :researchers, :city
    remove_column :researchers, :province
    remove_column :researchers, :postal_code
    remove_column :researchers, :phone
    remove_column :researchers, :primary_language
    remove_column :researchers, :date_of_birth

    change_column :users, :user_type, :string, :default => "community"

    create_table "reserachers", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end

    add_index "reserachers", ["user_id"], :name => "index_reserachers_on_user_id"
  end
end
