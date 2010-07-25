class CreateInnoDBTags < ActiveRecord::Migration
  def self.up
    create_table :innodb_tags do |t|
      t.column :article_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :type, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
