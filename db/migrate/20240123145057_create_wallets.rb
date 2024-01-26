class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.integer :balance
      t.references :accountable, polymorphic: true

      t.timestamps
    end
    add_index :wallets, [:accountable_type, :accountable_id]
  end
end
