# frozen_string_literal: true

module Website
  module Api
    class VerifyOnlinePayment < Rectify::Command
      attr_reader :payment

      def initialize(payment)
        @payment = payment
      end

      def call
        if payment.successful?
          Rails.logger.info(
            "[VerifyOnlinePaymentService] payment #{payment.payment_ref} is already successful, skipping"
          )
          return
        end

        pg_state = pg_data[:status]
        return payment if payment.reload.state.to_s == pg_state.to_s

        transaction do
          update_pg_data

          case pg_state.to_sym
          when :paid, :captured
            mark_payment_successful
          when :authorized
            mark_payment_authorized
          else
            Rails.logger.info(
              "PG payment state: #{pg_state} for payment_ref: #{payment.payment_ref} with state #{payment.state}, no action defined"
            )
          end
        end

        payment
      end

      private

      def mark_payment_successful
        payment.succeed!
      end

      def mark_payment_authorized
        payment.authorized!
      end

      def update_pg_data
        payment_info = pg_data
        payment.update!(
          pg_transaction_id: payment_info.delete(:id),
          payment_mode: payment_info.delete(:payment_mode),
          last_pg_error: payment_info.delete(:last_pg_error),
          pg_state: payment_info.delete(:status),
          pg_data: payment.pg_data.merge(payment_info)
        )
      end

      def pg_data
        @pg_data ||= Razorpay::Order.fetch(payment.pg_transaction_id).attributes.with_indifferent_access
      end
    end
  end
end
