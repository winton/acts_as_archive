class HasManies < ActiveRecord::Migration
  def self.up
    create_table :has_manies do |t|
      t.string :string, :default => 'string'
      t.integer :integer, :default => '1'
      t.integer :record_id
      t.timestamps
    end
  end

  def self.down
    drop_table :has_manies
  end
end
