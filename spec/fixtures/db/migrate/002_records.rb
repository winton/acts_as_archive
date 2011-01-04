class Records < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.string :string, :default => 'string'
      t.integer :integer, :default => '1'
      t.integer :belongs_to_id
      t.datetime :restored_at
      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
