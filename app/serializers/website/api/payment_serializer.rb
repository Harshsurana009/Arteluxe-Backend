module Website
  module Api
    class PaymentSerializer < ActiveModel::Serializer
      attributes :amount, :payment_ref, :currency, :state, :created_at

      def amount
        object.amount.to_f
      end
    end
  end
end