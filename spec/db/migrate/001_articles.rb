class Articles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :blah
    end
  end

  def self.down
    drop_table :articles
  end
end
