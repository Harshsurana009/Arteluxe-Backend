module Website
  module Api
    # == Create Payment
    # Service object to create payment
    class CreatePayment < Rectify::Command
      def initialize(order)
        @order = order
      end

      def call
        transaction do
          create_payment
          pg_order = create_pg_order
          update_payment(pg_order)
          schedule_payment_capture

          broadcast(:ok, @payment)
        end
      end

      private

      attr_reader :order, :payment

      def create_payment
        @payment = @order.customer_payments.create!(
          amount: @order.amount
        )
      end

      def create_pg_order
        pg_order = create_razopay_order

        if pg_order.attributes['id'].blank?
          raise "Razorpay failed to create order for payment #{payment.payment_ref}, pg_order: #{pg_order.as_json}"
        end

        pg_order
      end

      def update_payment(pg_order)
        payment.update!(
          pg_transaction_id: pg_order.attributes['id'],
          pg_state: pg_order.attributes['status'],
          pg_data: pg_order.as_json
        )

        payment.initiate!
      end

      def schedule_payment_capture
        # payment_verification_delay = [5, 20]
        # payment_verification_delay.each do |delay|
        #   VerifyOnlinePaymentJob.set(wait_until: delay.minutes.from_now).perform_later(payment)
        # end
      end

      def create_razopay_order
        params = {
          amount: in_small_units(payment.amount),
          currency: 'INR',
          receipt: order.order_ref,
          payment: capture_setting,
          notes: {}
        }

        Razorpay::Order.create(params)
      end

      def capture_setting
        {
            capture: 'automatic',
            capture_options: {
              automatic_expire_period: Payment::AUTOCAPTURE_WINDOW_IN_MINUTES,
              refund_speed: 'normal'
            }
        }
      end

      def in_small_units(amount)
        (amount * 100).to_i
      end
    end
  end
end