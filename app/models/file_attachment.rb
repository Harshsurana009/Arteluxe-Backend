# frozen_string_literal: true

class FileAttachment < ApplicationRecord
  self.table_name = 'file_attachments'

  # Constants
  VALID_TYPES = %w[
    Image
    Video
    Document
  ].freeze

  # Associations
  has_many :resource_attachments

  # Validations
  validates :type, presence: true
  validates :type, inclusion: { in: VALID_TYPES }

  # Scopes
  scope :videos, -> { where(type: 'Video') }
  scope :documents, -> { where(type: 'Document') }
end
