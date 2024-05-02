# frozen_string_literal: true

class Image < FileAttachment
  include Rails.application.routes.url_helpers

  CONTENT_TYPE = %w[image/png
                    image/jpeg
                    image/gif
                    image/jpg
                    image/bmp
                    image/tiff
                    image/webp
                    image/svg+xml].freeze
  IMG_MAX_SIZE = 25.megabytes
  IMG_VARIANTS = {
    thumbnail: { height: 300, width: 400 },
    small_thumbnail: { height: 200, width: 200 },
    placeholder: { height: 5, width: 5 },
    # width is nil, since width should be auto in this case
    ui_gallery: { height: 600, width: nil },
    mobile_web_gallery: { height: 650, width: 576 },
    small_mobile_size: { height: 220, width: 375 },
    mobile_size: { height: 340, width: 576 },
    tablet_size: { height: 450, width: 768 },
    desktop_size: { height: 705, width: 1200 },
    widescreen_size: { height: 1080, width: 1840 },
    logo: { height: 400, width: nil }
  }.freeze

  has_one_attached :image

  validates :image,
            attached: true,
            content_type: CONTENT_TYPE,
            size: { less_than: IMG_MAX_SIZE }

  def file_name
    image.blob.filename
  end

  def file_type
    'image'
  end

  def original_url(_expires = false)
    serv = Rails.application.config.active_storage.service
    # cdn_path = "filestore/#{image.key}"
    if %i[local test production microsoft cloudinary].include? serv
      Cloudinary::Utils.cloudinary_url(
            image.key,
            transformation: [
              {
                crop: 'fill',
                gravity: 'auto',
                quality: 'auto',
                fetch_format: 'auto',
                flags: ['progressive', 'strip_profile']
              }
            ]
          )
    else
      url_for(image)
    end
  end

  IMG_VARIANTS.each do |img_style_name, _image_dimensions|
    define_method("#{img_style_name}_url") do
      serv = Rails.application.config.active_storage.service
      if %i[local production test microsoft cloudinary].include? serv
        Cloudinary::Utils.cloudinary_url(
            image.key,
            transformation: [
              {
                crop: 'fill',
                gravity: 'auto',
                quality: 'auto',
                fetch_format: 'auto',
                flags: ['progressive', 'strip_profile']
              }
            ]
          )
      else
        url_for(image)
      end
    end
  end
end
