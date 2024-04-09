# frozen_string_literal: true

module Admin
  module Api
    class ImageSerializer < ActiveModel::Serializer
      attributes :id, :type, :media_urls

      def media_urls
        {
          thumbnail: object.thumbnail_url,
          original: object.original_url
        }
      end
    end
  end
end
