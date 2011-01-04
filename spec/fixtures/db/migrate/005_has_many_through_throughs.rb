class HasManyThroughThroughs < ActiveRecord::Migration
  def self.up
    create_table :has_many_through_throughs do |t|
      t.string :string, :default => 'string'
      t.integer :integer, :default => '1'
      t.integer :has_many_through_id
      t.integer :record_id
      t.datetime :restored_at
      t.timestamps
    end
  end

  def self.down
    drop_table :has_many_through_throughs
  end
end
