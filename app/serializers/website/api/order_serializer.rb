module Website
  module Api
    class OrderSerializer < ActiveModel::Serializer
      attributes :id, :amount, :state, :created_at, :bookings,
                 :payments, :address, :order_ref

      def amount
        object.amount.to_f
      end

      def bookings
        BulkSerializer.new(
          object: object.bookings,
          serializer: BookingSerializer
        ).as_json
      end

      def payments
        BulkSerializer.new(
          object: object.payments,
          serializer: PaymentSerializer
        ).as_json
      end

      def address
        return {} if object.address.blank?

        AddressSerializer.new(object.address).as_json
      end
    end
  end
end