class HasOneThroughThroughs < ActiveRecord::Migration
  def self.up
    create_table :has_one_through_throughs do |t|
      t.integer :record_id
    end
  end

  def self.down
    drop_table :has_one_through_throughs
  end
end
