class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :title, :string, :null => false
      t.column :body, :text, :null => false
      t.column :delete_at, :datetime

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
