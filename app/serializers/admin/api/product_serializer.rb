module Admin
  module Api
    class ProductSerializer < ActiveModel::Serializer
      attributes :id, :name, :price, :sticker_price, :category, :description, :state, :created_at, :updated_at,
      :image_url

      def image_url
        object.file_attachments.first&.original_url
      end
    end
  end
end
