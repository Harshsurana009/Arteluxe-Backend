module Website
  module Api
    class CartSerializer < ActiveModel::Serializer
      attributes :id, :items, :amount, :quantity

      def items
        BulkSerializer.new(
          object: object.items,
          serializer: CartItemSerializer
        ).as_json
      end
    end
  end
end
