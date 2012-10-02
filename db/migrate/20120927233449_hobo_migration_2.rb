class HoboMigration2 < ActiveRecord::Migration
  def self.up
    create_table :consents do |t|
      t.date     :date
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :consent_text_id
    end
    add_index :consents, [:user_id]
    add_index :consents, [:consent_text_id]

    create_table :consent_texts do |t|
      t.string   :title
      t.text     :body
      t.datetime :created_at
      t.datetime :updated_at
    end

    remove_column :users, :has_consented
  end

  def self.down
    add_column :users, :has_consented, :boolean, :default => false

    drop_table :consents
    drop_table :consent_texts
  end
end
