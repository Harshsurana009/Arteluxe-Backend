module Website
  module Api
    class RazorpayPaymentSerializer < ActiveModel::Serializer
      attributes :key_id, :amount, :pg_transaction_id, :customer_details, :created_at

      def key_id
        Rails.application.credentials.razorpay[:key_id]
      end

      def amount
        object.amount.to_f
      end

      def customer_details
        customer = object.order.customer

        {
          name: customer.full_name,
          email: customer.email,
          phone: customer.phone
        }
      end
    end
  end
end