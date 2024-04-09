# frozen_string_literal: true

class Document < FileAttachment
  include Rails.application.routes.url_helpers

  CONTENT_TYPE = %w[application/zip
                    application/msword
                    application/vnd.ms-office
                    application/vnd.ms-excel
                    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                    application/pdf
                    text/csv].freeze
  DOC_MAX_SIZE = 20.megabytes

  has_one_attached :document
  validates :document,
            attached: true,
            content_type: CONTENT_TYPE,
            size: { less_than: DOC_MAX_SIZE }

  def file_name
    document.blob.filename
  end

  def file_type
    'document'
  end

  def original_url(expires = true)
    serv = Rails.application.config.active_storage.service
    if %i[local test].include? serv
      if document.blob.content_type == 'text/csv'
        url_for(document) + '.csv'
      else
        url_for(document)
      end
    else
      expires ? document.service_url : document.service_url(expires_in: 2.years)
    end
  end
end
