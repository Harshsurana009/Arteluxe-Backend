module Website
  module Api
    class BookingSerializer < ActiveModel::Serializer
      attributes :amount, :unit_price, :quantity, :product_details

      def amount
        object.amount.to_f
      end

      def unit_price
        object.unit_price.to_f
      end

      def product_details
        {
          id: object.product.id,
          name: object.product.name,
          price: object.product.price,
          sticker_price: object.product.sticker_price,
          category: object.product.category
        }
      end
    end
  end
end