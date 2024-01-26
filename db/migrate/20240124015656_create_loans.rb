class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.integer :amount
      t.string :status
      t.integer :user_id, index: true
      t.integer :admin_id, index: true
      t.integer :interest, default: 5
      t.string :reason
      t.string :name
      t.integer :interest_amount
      t.integer :interest_count, default: 1
      t.integer :payable_amount
      t.datetime :interest_updated_at

      t.timestamps
    end
  end
end
