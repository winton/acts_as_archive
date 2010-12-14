class HasManyThroughThroughs < ActiveRecord::Migration
  def self.up
    create_table :has_many_through_throughs do |t|
      t.integer :has_many_through_id
      t.integer :record_id
    end
  end

  def self.down
    drop_table :has_many_through_throughs
  end
end
