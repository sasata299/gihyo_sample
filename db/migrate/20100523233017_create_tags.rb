class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :article_id, :integer, :null => false
      t.column :name, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
