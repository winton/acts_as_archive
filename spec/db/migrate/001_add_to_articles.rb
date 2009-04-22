class AddToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :permalink, :string
  end

  def self.down
    remove_column :articles, :permalink
  end
end
