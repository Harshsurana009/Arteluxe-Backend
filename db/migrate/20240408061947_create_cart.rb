class CreateCart < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :customer, null: false
      t.timestamps
    end

    create_table :cart_items do |t|
      t.references :cart, null: false
      t.references :product, null: false
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
