# frozen_string_literal: true

module Website
  module Api
    # == Auth Controller
    # Provides basic authetication methods.
    # Provides forgot password and reset password methods
    class AuthController < ApplicationController
      def sign_in
        AuthenticateCustomer.call(customer_params[:email],
                                  customer_params[:password]) do
          on(:ok) { |token| render json: token }
          on(:invalid_credentials) do
            raise 'Invalid credentials'
          end
          on(:required_fields_missing) do |req_field|
            raise "Required field missing: #{req_field}"
          end
          on(:unconfirmed) do
            raise 'Account not confirmed'
          end
        end
      end

      def sign_up
        create_customer = CustomerForm.from_params(customer_params)
        CreateCustomer.call(create_customer) do
          on(:ok) do |customer|
            data = CustomerSerializer.new(customer).as_json.merge!(access_token: access_token(customer))
            render json: data, status: :created
          end
          on(:invalid) do |error_messages|
            render json: error_messages, status: :unprocessable_entity
            return
          end
        end
      end

      private

      def customer_params
        eval(params[:data]).with_indifferent_access
      end

      def token_expiry
        7.days.freeze
      end

      def access_token(customer)
        payload = { customer_id: customer.id }
        JsonWebToken.encode_token(payload, Time.zone.now + token_expiry)
      end
    end
  end
end
