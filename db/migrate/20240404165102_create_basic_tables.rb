class CreateBasicTables < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :full_name, null: false
      t.string :phone, null: false, index: { unique: true }
      t.string :phone_country_code, null: false
      t.integer :password_reset_attempts, default: 0
      t.datetime :reset_password_expires_at
      t.string :reset_password_token
      t.string :password_digest, null: false
      t.string :email, null: false
      t.boolean :email_verified, null: false, default: false
      t.string :email_verification_token
      t.boolean :phone_verified, null: false, default: false
      t.integer :phone_otp_reset_attempts, default: 0, null: false
      t.index 'lower(email)', unique: true
      t.timestamps
    end

    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :state, null: false, index: true
      t.decimal :sticker_price, null: false
      t.decimal :price, null: false
      t.string :category, array: true, null: false, default: []
      t.text :description, null: false
      t.timestamps
    end

    create_table :orders do |t|
      t.references :customer, null: false
      t.string :state, null: false, index: true
      t.decimal :amount, null: false, default: 0
      t.string :code, null: false
      t.index 'lower(code)', unique: true
      t.timestamps
    end

    create_table :bookings do |t|
      t.references :customer, null: false
      t.references :product, null: false
      t.references :order, null: false
      t.integer :quantity, null: false
      t.decimal :unit_price, null: false, default: 0
      t.decimal :amount, null: false, default: 0
      t.string :code, null: false
      t.index 'lower(code)', unique: true
      t.timestamps
    end

    create_table :active_storage_blobs do |t|
      t.string   :key,        null: false
      t.string   :filename,   null: false
      t.string   :content_type
      t.text     :metadata
      t.bigint   :byte_size,  null: false
      t.string   :checksum,   null: false
      t.datetime :created_at, null: false

      t.index [:key], unique: true
    end

    create_table :active_storage_attachments do |t|
      t.string     :name,     null: false
      t.references :record,   null: false, polymorphic: true, index: false
      t.references :blob,     null: false

      t.datetime :created_at, null: false

      t.index %i[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    create_table :file_attachments do |t|
      t.references :resource, polymorphic: true, null: false
      t.string :type, null: false, index: true
      t.string :credits, default: [], array: true
      t.boolean :is_featured, default: false, null: false
      t.integer :position, null: false
      t.index %i[resource_type resource_id position], unique: true
      t.timestamps
    end

    create_table :otps do |t|
      t.string :otp_type, null: false
      t.integer :pin, null: false
      t.datetime :sent_at
      t.references :resource, polymorphic: true, null: false
      t.string :state, null: false
      t.timestamps
    end

    create_table :payments do |t|
      t.references :order, null: false
      t.decimal :amount, null: false
      t.string :state, null: false
      t.string :payment_mode
      t.jsonb :last_event_at
      t.string :remarks
      t.string :payment_ref, null: false
      t.string :pg_transaction_id
      t.string :type, null: false
      t.jsonb :pg_data, default: {}
      t.string :last_pg_error
      t.string :pg_state
      t.timestamps
    end
  end
end
