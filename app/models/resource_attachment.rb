# frozen_string_literal: true

require 'acts_as_list'

class ResourceAttachment < ApplicationRecord
  self.table_name = 'resource_attachments'

  # Associations
  belongs_to :resource, polymorphic: true
  belongs_to :file_attachment

  # Plugins
  acts_as_list column: :position, scope: %i[resource_type resource_id], sequential_updates: true

  # Validations
  validates :position, uniqueness: {
    scope: %i[resource_type resource_id],
    message: 'Position should be uniq'
  }
end
