# frozen_string_literal: true

module Website
  module Api
    # == Authorizecustomer
    # Service class written for authorizing customer every request based on the
    # token provided
    class AuthorizeCustomer < Rectify::Command
      def initialize(headers = {})
        @headers = headers
      end

      def call
        check_required_params
        decoded_token = decode_auth_token
        customer = authorize_customer(decoded_token)
        broadcast(:customer, customer)
      end

      private

      attr_reader :headers, :current_partner

      def decode_auth_token
        @decoded_auth_token ||= JsonWebToken.decode_token(headers['auth-token'])
      rescue StandardError
        broadcast(:token_expired)
      end

      def check_required_params
        broadcast(:token_missing) if headers['auth-token'].blank?
      end

      def authorize_customer(decoded_token)
        @customer ||= Customer.find_by(id: decoded_token['customer_id'])
        broadcast(:token_expired) unless @customer

        @customer
      end
    end
  end
end
