class CreateResourceAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :resource_attachments do |t|
      t.references :file_attachment, null: false, foreign_key: true
      t.references :resource, polymorphic: true, null: false
      t.integer :position, null: false
      t.index %i[resource_type resource_id position], unique: true
      t.timestamps
    end

    remove_column :file_attachments, :position
    remove_reference :file_attachments, :resource, polymorphic: true
  end
end
