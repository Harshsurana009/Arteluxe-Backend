module Website
  module Api
    class CartSerializer < ActiveModel::Serializer
      attributes :id, :items, :amount, :quantity

      def items
        BulkSerializer.new(
          object.items,
          each_serializer: CartItemSerializer
        ).as_json
      end
    end
  end
end
