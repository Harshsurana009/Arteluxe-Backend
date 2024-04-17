module Website
  module Api
    class CreateOrder < Rectify::Command
      def initialize(customer)
        @customer = customer
        @cart = customer.cart
      end

      def call
        transaction do
          validate_customer_cart

          create_order
          create_bookings
          empty_cart
          return broadcast(:ok, order)
        end

        return broadcast(:invalid, 'Something went wrong')
      end

      private

      attr_accessor :customer, :cart, :order

      def validate_customer_cart
        if cart.items.empty?
          raise 'Cart is empty'
        end
      end

      def create_order
        @order = customer.orders.create!(amount: cart.amount)
      end

      def create_bookings
        booking_params = cart.items.map do |item|
          unit_price = item.product.price
          quantity = item.quantity

          {
            product_id: item.product_id, 
            quantity: item.quantity,
            unit_price: item.product.price,
            amount: unit_price * quantity,
            customer_id: order.customer_id,
          }
        end

        order.bookings.create!(booking_params)
      end

      def empty_cart
        cart.items.destroy_all # TODO make state machine for cart
      end
    end
  end
end