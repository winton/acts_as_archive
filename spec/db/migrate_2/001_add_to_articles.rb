class AddToArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :deleted_at
  end

  def self.down
    add_column :articles, :deleted_at, :string
  end
end
