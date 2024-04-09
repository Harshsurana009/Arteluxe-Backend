# frozen_string_literal: true

class Video < FileAttachment
  include Rails.application.routes.url_helpers
  CONTENT_TYPE = %w[video/mp4
                    video/mpeg
                    video/webm
                    video/avi
                    video/mkv
                    video/mov
                    video/quicktime].freeze
  VIDEO_MAX_SIZE = 100.megabytes

  has_one_attached :video
  validates :video,
            attached: true,
            content_type: CONTENT_TYPE,
            size: { less_than: VIDEO_MAX_SIZE }

  def file_name
    video.blob.filename
  end

  def file_type
    'video'
  end

  def original_url(_expires = false)
    serv = Rails.application.config.active_storage.service
    if %i[local test].include? serv
      Rails.application.routes.url_helpers.url_for(video)
    else
      video.service_url
    end
  end

  def thumbnail_url
    thumbnail_sizes = Image::IMG_VARIANTS[:thumbnail]
    if %i[local test].include? serv
      preview = video.blob.preview(
        resize: "#{thumbnail_sizes[0]}X#{thumbnail_sizes[1]}"
      ).processed
      url_for(preview)
    else
      video.service_url
    end
  end

  def duration
    duration = video.blob.metadata[:duration]&.round(2)
    if %i[local test].include? serv
      duration ||
        ActiveStorage::Analyzer::VideoAnalyzer.new(
          video.blob
        ).metadata[:duration]&.round(2)
    else
      duration
    end
  end

  private

  def serv
    Rails.application.config.active_storage.service
  end

  def cdn_path_without_extension
    cdn_path.split('.')[0]
  end
end
