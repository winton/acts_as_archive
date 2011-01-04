class HasManyThroughs < ActiveRecord::Migration
  def self.up
    create_table :has_many_throughs do |t|
      t.string :string, :default => 'string'
      t.integer :integer, :default => '1'
      t.datetime :restored_at
      t.timestamps
    end
  end

  def self.down
    drop_table :has_many_throughs
  end
end
