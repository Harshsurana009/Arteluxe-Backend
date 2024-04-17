class CreateAddress < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :resource, polymorphic: true, index: true
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.text :address, null: false
      t.string :zip_code, null: false
      t.timestamps
    end

    add_reference :orders, :address, foreign_key: true, index: true
  end
end
