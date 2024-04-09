module Website
  module Api
    class CartItemSerializer < ActiveModel::Serializer
      attributes :id, :product_id, :quantity, :product_name, :product_price,
                 :product_image_url, :amount

      def product_name
        object.product.name
      end

      def product_price
        object.product.price
      end

      def product_image_url
        object.product.file_attachments.first&.original_url
      end
    end
  end
end
