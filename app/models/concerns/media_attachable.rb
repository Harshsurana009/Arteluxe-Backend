# frozen_string_literal: true

# Adds media association
module MediaAttachable
  extend ActiveSupport::Concern

  included do
    has_many :resource_attachments, as: :resource, dependent: :destroy
    has_many :file_attachments, -> { order(position: :asc) },
             through: :resource_attachments, index_errors: true, dependent: :destroy

    # has_one :featured_media,
    #         -> { order('case when is_featured then 1 else 2 end, position').limit(1) },
    #         as: :resource,
    #         class_name: 'ResourceAttachment'
  end
end
