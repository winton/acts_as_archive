class BelongsTos < ActiveRecord::Migration
  def self.up
    create_table :belongs_tos do |t|
      t.string :string, :default => 'string'
      t.integer :integer, :default => '1'
      t.datetime :restored_at
      t.timestamps
    end
  end

  def self.down
    drop_table :belongs_tos
  end
end
