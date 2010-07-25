class CreateInnodbArticles < ActiveRecord::Migration
  def self.up
    create_table :innodb_articles do |t|
      t.column :title, :string, :null => false
      t.column :body, :text, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :innodb_articles
  end
end
